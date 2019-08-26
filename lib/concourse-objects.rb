# frozen_string_literal: true

require "set"  # SPDX-License-Identifier: Ruby
require "yaml" # SPDX-License-Identifier: Ruby

module ConcourseObjects
  class Object
    def self.call(object)
      case object
      when self  then object
      when Hash  then new(object)
      when Array then object.map(&self)
      when nil   then nil
      else raise TypeError, "#{self.class.inspect} does not know how to parse #{object.class}(#{object.inspect})"
      end
    end

    def self.to_proc
      proc { |*rest| self.call(*rest) }
    end

    AsString  = ->(source) { String(source) }
    AsInteger = ->(source) { Integer(source) }
    AsHash    = ->(source) { Hash(source) }
    AsHashOf  = ->(keys, values, source) { AsHash.(source).transform_keys(&keys).transform_keys(&values) }.curry
    AsBoolean = ->(source) { source ? true : false }
    AsArray   = lambda do |source|
      case source
      when Array then source
      when Hash  then [source]
      else Array(source)
      end
    end
    AsArrayOf = ->(entries, source) { AsArray.(source).map(&entries) }.curry

    Nothing    = proc { nil }
    EmptyArray = proc { []  }
    EmptyHash  = proc { {}  }
    Enum       = ->(*values) { ->(value) { value if values.include?(value) } }

    def hash
      self.to_h.hash
    end

    def eql?(other)
      self.hash == other.hash
    end

    def initialize(options = {})
      options.transform_keys(&:to_sym).yield_self do |options|
        # if ENV["REPORT_UNKNOWN_KEYS"]
        #   (Set.new(options.keys) - self.class.attributes).each do |attr|
        #     STDERR.puts "#{self.class.inspect} has no attribute :#{attr}"
        #   end
        # end

        self.class.required_attributes.each do |required|
          if options.key?(required)
            self.public_send("#{required}=", options.fetch(required))
          else
            raise KeyError, "#{self.class.inspect} is missing required attribute: #{required}"
          end
        end

        self.class.optional_attributes.each do |optional|
          self.public_send("#{optional}=", options.fetch(optional)) if options.key?(optional)
        end

        yield self, options if block_given?
      end
    end
    
    def self.keys
      instance_methods(false).map(&:to_s)
    end

    def to_h
      instance_variables.map(&:to_s).sort.map do |key|
        instance_variable_get(key.delete_prefix("@").prepend("@")).yield_self do |value|
          [
            key.delete_prefix("@"),
            (
              if (Array === value)
                value.map do |value|
                  ((ConcourseObjects::Object === value) ? value.to_h : value)
                end
              else
                ((ConcourseObjects::Object === value) ? value.to_h : value)
              end
              )
          ] unless key.match? /@_/
        end
      end.to_h.compact
    end

    def to_yaml
      YAML.dump(self.to_h)
    end

    def __instance_variable_name(name)
      String(name).delete_suffix("?").delete_suffix("=").prepend("@").to_sym
    end

    def self.map(callable)
      ->(enumerable) { enumerable.map(&callable) }
    end

    def self.singleton_class_Set(*attrs)
      String(__callee__).prepend("@@").yield_self do |class_variable|
        if singleton_class.class_variable_defined?(class_variable)
          singleton_class.class_variable_get(class_variable)
        else
          singleton_class.class_variable_set(class_variable, Set.new)
        end.tap do |set|
          attrs.reduce(set, :<<)
        end
      end
    end

    singleton_class.alias_method :required_attributes, :singleton_class_Set
    singleton_class.alias_method :readable_attributes, :singleton_class_Set
    singleton_class.alias_method :writable_attributes, :singleton_class_Set

    def self.attributes
      readable_attributes + writable_attributes
    end

    def self.optional_attributes
      attributes - required_attributes
    end

    def self.readable(attr, &default)
      String(attr).yield_self do |attr|
        define_method("#{attr}?") do
          not instance_variable_get("@#{attr}").nil?
        end

        define_method(attr) do
          if instance_variable_defined?("@#{attr}")
            instance_variable_get("@#{attr}")
          else
            default.(self) if default
          end
        end

        readable_attributes << attr.to_sym

        return attr.to_sym
      end
    end

    def self.writable(attr, transforms = [], &guard)
      Array(transforms).map do |transform|
        if transform.respond_to?(:call)
          transform
        elsif transform.respond_to?(:to_proc)
          transform.to_proc
        elsif transform.is_a?(Class)
          ->(object) { object.send(transform.name, object) }
        else
          raise TypeError, "transformations must be callable"
        end
      end.yield_self do |transforms|
        String(attr).yield_self do |attr|
          define_method("#{attr}=") do |value|
            return unless guard.(self, value) if guard

            if value.nil?
              remove_instance_variable("@#{attr}")
            else
              transforms.reduce(value) do |value, transform|
                transform.(value)
              end.yield_self do |value|
                instance_variable_set("@#{attr}", value)
              end
            end
          end

          writable_attributes << attr.to_sym

          return attr.to_sym
        end
      end
    end

    def self.optional(attr, required: false, write: [], default: nil, guard: nil)
      readable(attr, &default)
      writable(attr, write, &guard)

      return attr.to_sym
    end

    def self.required(attr, *rest)
      required_attributes << optional(attr, *rest)

      return attr.to_sym
    end

    def self.inherited(child)
      self.required_attributes.reduce(child.required_attributes, :<<)
      self.readable_attributes.reduce(child.readable_attributes, :<<)
      self.writable_attributes.reduce(child.writable_attributes, :<<)
    end
  end

  class Step < Object
    class InParallel < Object
      DEFAULT_FAIL_FAST = false

      def self.call(object)
        case object
        when Array then new("steps" => object)
        else super(object)
        end
      end

      optional :steps,     write: AsArrayOf.(Step), default: EmptyArray
      optional :fail_fast, write: AsBoolean,        default: proc { DEFAULT_FAIL_FAST }
      optional :limit,     write: AsInteger
    end

    DEFAULT_PRIVILEGED  = false
    DEFAULT_TRIGGER     = false
    DEFAULT_VERSION     = "latest"
    ACCEPTABLE_VERSIONS = ["latest", "every", Hash]

    TYPES = %i[get put task in_parallel aggregate do try]

    def initialize(options = {})
      super(options) # first pass, as some keys are only acceptable if others are set first.
      super(options) do |this, options|
        raise KeyError, "#{self.class.inspect} is missing one of: (#{TYPES.join(' || ')})" unless TYPES.any? { |key| options.key?(key) }
        raise KeyError, "#{self.class.inspect} is missing one of: (config || file)" if this.task? unless %i[config file].any? { |key| options.key?(key) }
        yield this, options if block_given?
      end
    end

    IsTask       = proc { |step| step.task? }
    IsPut        = proc { |step| step.put? }
    IsGet        = proc { |step| step.get? }
    UsesResource = proc { |step| step.get? or step.put? }
    IsAction     = proc { |step| step.get? or step.put? or step.task? }

    optional :in_parallel,    write: Step::InParallel
    optional :aggregate,      write: AsArrayOf.(Step),  default: EmptyArray
    optional :do,             write: AsArrayOf.(Step),  default: EmptyArray
    optional :tags,           write: AsArrayOf.(:to_s), default: EmptyArray
    optional :params,         write: AsHash,            default: EmptyHash,                   guard: IsAction
    optional :get_params,     write: AsHash,            default: EmptyHash,                   guard: IsPut
    optional :inputs,         write: AsArrayOf.(:to_s), default: EmptyArray,                  guard: IsPut
    optional :passed,         write: AsArrayOf.(:to_s), default: EmptyArray,                  guard: IsGet
    optional :trigger,        write: AsBoolean,         default: proc { DEFAULT_TRIGGER },    guard: IsGet
    optional :resource,       write: AsString,          default: proc { |step| step.name },   guard: UsesResource
    optional :privileged,     write: AsBoolean,         default: proc { DEFAULT_PRIVILEGED }, guard: IsTask
    optional :vars,           write: AsHash,            default: EmptyHash,                   guard: IsTask
    optional :input_mapping,  write: AsHash,            default: EmptyHash,                   guard: IsTask
    optional :output_mapping, write: AsHash,            default: EmptyHash,                   guard: IsTask
    optional :config,         write: AsHash,            default: EmptyHash,                   guard: IsTask
    optional :file,           write: AsString,                                                guard: IsTask
    optional :image,          write: AsString,                                                guard: IsTask
    optional :get,            write: AsString
    optional :put,            write: AsString
    optional :task,           write: AsString
    optional :timeout,        write: AsString
    optional :attempts,       write: AsInteger
    optional :on_abort,       write: Step
    optional :on_failure,     write: Step
    optional :on_success,     write: Step
    optional :try,            write: Step

    readable(:version) { DEFAULT_VERSION }

    def version=(version)
      case version
      when Hash then @version = version
      when nil  then remove_instance_variable(:@version)
      else
        String(version).yield_self do |version|
          unless ACCEPTABLE_VERSIONS.any? { |av| av === version }
            raise TypeError, %{#{self.class.inspect} expects :version to be one of: #{ACCEPTABLE_VERSIONS}, instead got: "#{version}"}
          end
          @version = version
        end
      end
    end

    writable_attributes << :version

    def name
      case type
      when :get  then @get
      when :put  then @put
      when :task then @task
      else nil
      end
    end

    def type
      return :get         if @get
      return :put         if @put
      return :task        if @task
      return :in_parallel if @in_parallel
      return :do          if @do
      return :try         if @try
      return :aggregate   if @aggregate
      nil
    end

    def self.to_proc
      Proc.new do |*rest|
        self.call(*rest)
      end
    end
  end
  
  class RetentionConfig < Object    
    optional :builds, write: AsInteger
    optional :days,   write: AsInteger
  end

  class Job < Object
    DEFAULT_DISABLE_MANUAL_TRIGGER = false
    DEFAULT_INTERRUPTIBLE          = false
    DEFAULT_PUBLIC                 = false
    DEFAULT_SERIAL                 = false

    required :name,                    write: AsString
    required :plan,                    write: AsArrayOf.(Step),  default: EmptyArray
    
    optional :serial_groups,           write: AsArrayOf.(:to_s), default: EmptyArray
    optional :max_in_flight,           write: AsInteger,         default: proc { |job| 1 if job.serial or job.serial_groups.any? }
    optional :build_log_retention,     write: RetentionConfig,   default: proc { RetentionConfig.new }
    optional :disable_manual_trigger,  write: AsBoolean,         default: proc { DEFAULT_DISABLE_MANUAL_TRIGGER }
    optional :interruptible,           write: AsBoolean,         default: proc { DEFAULT_INTERRUPTIBLE }
    optional :public,                  write: AsBoolean,         default: proc { DEFAULT_PUBLIC }
    optional :serial,                  write: AsBoolean,         default: proc { DEFAULT_SERIAL }
    optional :old_name,                write: AsString
    optional :ensure,                  write: Step
    optional :on_abort,                write: Step
    optional :on_failure,              write: Step
    optional :on_success,              write: Step

    def initialize(options = {})
      super(options) do |this, options|
        this.build_log_retention = { builds: options.fetch(:build_logs_to_retain) } if options.key?(:build_logs_to_retain) unless this.build_log_retention?

        yield this, options if block_given?
      end
    end
  end

  class Resource < Object
    DEFAULT_CHECK_EVERY = "1m".freeze
    DEFAULT_PUBLIC      = false

    required :name,          write: AsString
    required :type,          write: AsString

    optional :check_every,   write: AsString,         default: proc { DEFAULT_CHECK_EVERY }
    optional :public,        write: AsBoolean,        default: proc { DEFAULT_PUBLIC }
    optional :tags,          write: AsArrayOf.(to_s), default: EmptyArray
    optional :source,        write: AsHash,           default: EmptyHash
    optional :icon,          write: AsString
    optional :version,       write: AsString
    optional :webhook_token, write: AsString
  end

  class ResourceType < Object
    DEFAULT_PRIVILEGED             = false
    DEFAULT_CHECK_EVERY            = "1m".freeze
    DEFAULT_UNIQUE_VERSION_HISTORY = false

    required :name,                   write: AsString
    required :type,                   write: AsString
    
    optional :source,                 write: AsHash,            default: EmptyHash
    optional :params,                 write: AsHash,            default: EmptyHash
    optional :privileged,             write: AsBoolean,         default: proc { DEFAULT_PRIVILEGED  }
    optional :unique_version_history, write: AsBoolean,         default: proc { DEFAULT_UNIQUE_VERSION_HISTORY }
    optional :check_every,            write: AsString,          default: proc { DEFAULT_CHECK_EVERY }
    optional :tags,                   write: AsArrayOf.(:to_s), default: EmptyArray
  end

  class Group < Object    
    required :name,      write: AsString

    optional :jobs,      write: AsArrayOf.(:to_s), default: EmptyArray
    optional :resources, write: AsArrayOf.(:to_s), default: EmptyArray
  end

  class Pipeline < Object
    optional :jobs,           write: AsArrayOf.(Job),          default: EmptyArray
    optional :resources,      write: AsArrayOf.(Resource),     default: EmptyArray
    optional :resource_types, write: AsArrayOf.(ResourceType), default: EmptyArray
    optional :groups,         write: AsArrayOf.(Group),        default: EmptyArray
  end

  class RunConfig < Object    
    required :path, write: AsString
    
    optional :args, write: AsArray.(:to_s), default: EmptyArray
    optional :dir,  write: AsString
    optional :user, write: AsString
  end

  class ImageResource < Object
    required :type,    write: AsString
    required :source,  write: AsHash
    
    optional :params,  write: AsHash
    optional :version, write: AsHashOf.(:to_s, :to_s)
  end

  class ContainerLimits < Object
    optional :cpu,    write: AsInteger
    optional :memory, write: AsInteger
  end

  class Input < Object
    DEFAULT_OPTIONAL = false

    required :name,     write: AsString
    
    optional :path,     write: AsString
    optional :optional, write: AsBoolean, default: proc { DEFAULT_OPTIONAL }
  end

  class Output < Object
    required :name, write: AsString
    
    optional :path, write: AsString
  end

  class Cache < Object
    required :path, write: AsString
  end

  class Task < Object
    required :platform,         write: AsString
    required :run,              write: RunConfig
    
    optional :rootfs_uri,       write: AsString
    optional :image_resource,   write: ImageResource
    optional :container_limits, write: ContainerLimits,         default: proc { ContainerLimits.new }
    optional :inputs,           write: AsArrayOf.(Input),       default: EmptyArray
    optional :outputs,          write: AsArrayOf.(Output),      default: EmptyArray
    optional :caches,           write: AsArrayOf.(Cache),       default: EmptyArray
    optional :params,           write: AsHashOf.(:to_s, :to_s), default: EmptyHash
  end
end
