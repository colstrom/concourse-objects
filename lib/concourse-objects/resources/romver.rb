# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class RomVer < Resource
      RESOURCE_NAME     = "romver"
      RESOURCE_LICENSE  = "Apache-2.0"
      GITHUB_OWNER      = "cappyzawa"
      GITHUB_REPOSITORY = "cappyzawa/romver-resource"
      GITHUB_VERSION    = "v0.0.10"

      class Source < Object
        class Git < Source
          ValueIsPositive         = proc { |_, value| value.positive? }

          required :branch,         write: AsString
          required :file,           write: AsString
          required :uri,            write: AsString

          optional :commit_message, write: AsString
          optional :git_user,       write: AsString
          optional :password,       write: AsString
          optional :private_key,    write: AsString
          optional :username,       write: AsString
          optional :depth,          write: AsInteger, guard: ValueIsPositive

          def initialize(options = {})
            super(options.merge(driver: "git")) do |this, options|
              yield this, options if block_given?
            end
          end
        end

        ACCEPTABLE_DRIVERS = ["git"]
        DriverIsAcceptable = proc { |_, driver| ACCEPTABLE_DRIVERS.include?(driver) }

        required :driver, write: AsString, guard: DriverIsAcceptable

        optional :initial_version, write: AsString
      end

      class InParams < Object
        optional :bump, write: AsBoolean
      end

      class OutParams < Object
        optional :bump, write: AsBoolean
        optional :file, write: AsString

        def initialize(options = {})
          super(options) do |this, options|
            raise KeyError, "#{self.class.inspect} requires one of (bump, file)" unless (this.bump? or this.file?)

            yield this, options if block_given?
          end
        end
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "romver")) do |this, options|
          if this.source?
            options.fetch(:source).yield_self do |source|
              case this.source.driver
              when "git"   then Source::Git.(source)
              else Source.(source)
              end.yield_self do |source|
                this.send(:instance_variable_set, :@source, source)
              end
            end
          end

          yield this, options if block_given?
        end
      end
    end
  end
end
