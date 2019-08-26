# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Flyway < Resource
      RESOURCE_NAME     = "cf-flyway"
      GITHUB_OWNER      = "emerald-resource"
      GITHUB_REPOSITORY = "emerald-resource/cf-flyway-resource"
      GITHUB_VERSION    = "v1.0.1"

      class Source < Object
        required :api,          write: AsString
        required :username,     write: AsString
        required :password,     write: AsString
        required :organization, write: AsString
        required :space,        write: AsString
        required :service,      write: AsString
      end

      class OutParams < Object
        DEFAULT_CLEAN_DISABLED = false
        DEFAULT_COMMANDS       = ["info", "migrate", "info"]
        ACCEPTABLE_COMMANDS    = ["migrate", "clean", "info", "validate", "undo", "baseline", "repair"]
        CommandsAreAcceptable  = proc { |_, commands| commands.all? { |command| ACCEPTABLE_COMMANDS.include?(command) } }

        required :locations,          write: AsString
        
        optional :commands,           write: AsArrayOf.(:to_s), default: proc { DEFAULT_COMMANDS },           guard: CommandsAreAcceptable
        optional :clean_disabled,     write: AsBoolean,         default: proc { DEFAULT_CLEAN_DISABLED }
        optional :delete_service_key, write: AsBoolean,         default: proc { DEFAULT_DELETE_SERVICE_KEY }
        optional :flyway_conf,        write: AsString
        optional :jbdc_builder,       write: AsString
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "cf-flyway"))
      end
    end
  end
end
