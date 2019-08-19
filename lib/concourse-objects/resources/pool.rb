# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Pool < Resource
      RESOURCE_NAME     = "pool"
      GITHUB_OWNER      = "concourse"
      GITHUB_REPOSITORY = "concourse/pool-resource"
      GITHUB_VERSION    = "v1.0.3"

      class Source < Object
        DEFAULT_RETRY_DELAY = "10s"

        required :uri,    write: AsString
        required :branch, write: AsString
        required :pool,   write: AsString

        optional :private_key, write: AsString
        optional :username,    write: AsString
        optional :password,    write: AsString
        optional :retry_delay, write: AsString, default: proc { DEFAULT_RETRY_DELAY }
      end

      class InParams < Object
        ValueIsPositive         = proc { |_, value| value.positive? }

        optional :depth, write: AsInteger, guard: ValueIsPositive
      end

      class OutParams < Object
        optional :acquire,     write: AsBoolean
        optional :claim,       write: AsString
        optional :release,     write: AsString
        optional :add,         write: AsString
        optional :add_claimed, write: AsString
        optional :remove,      write: AsString
        optional :update,      write: AsString

        def initialize(options = {})
          super(options) do |this, options|
            raise KeyError, "expected one of: (#{self.class.optional_attributes.inspect})" unless self.class.optional_attributes.any? { |key| options.key?(key) }

            yield this, options if block_given?
          end
        end
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "pool")) do |this, options|
          yield this, options if block_given?
        end
      end
    end
  end
end
