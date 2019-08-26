# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class AlertManager < Resource
      RESOURCE_NAME     = "alertmanager"
      GITHUB_OWNER      = "frodenas"
      GITHUB_REPOSITORY = "frodenas/alertmanager-resource"
      GITHUB_VERSION    = "v0.3.0"

      class Source < Object
        required :url, write: AsString
      end

      class OutParams < Object
        class Silence < Object
          DEFAULT_EXPIRES = "1h"

          required :matchers, write: AsString

          optional :creator,  write: AsString
          optional :comments, write: AsString
          optional :expires,  write: AsString, default: proc { DEFAULT_EXPIRES }

          def initialize(options = {})
            super(options.merge(operation: "silence")) do |this, options|
              yield this, options if block_given?
            end
          end
        end

        class Expire < Object
          required :silence, write: AsString

          def initialize(options = {})
            super(options.merge(operation: "expire")) do |this, options|
              yield this, options if block_given?
            end
          end
        end

        ACCEPTABLE_OPERATIONS = ["silence", "expire"]
        OperationIsAcceptable = proc { |_, operation| ACCEPTABLE_OPERATIONS.include?(operation) }

        required :operation, write: AsString, guard: OperationIsAcceptable
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "alertmanager"))
      end
    end
  end
end
