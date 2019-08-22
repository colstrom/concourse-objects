# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Fly < Resource
      RESOURCE_NAME     = "fly"
      GITHUB_OWNER      = "troykinsella"
      GITHUB_REPOSITORY = "troykinsella/concourse-fly-resource"
      GITHUB_VERSION    = "v1.0.0"

      class Source < Object
        DEFAULT_DEBUG           = false
        DEFAULT_INSECURE        = false
        DEFAULT_MULTILINE_LINES = false
        DEFAULT_SECURE_OUTPUT   = false
        DEFAULT_TARGET          = "main"
        DEFAULT_TEAM            = "main"

        required :url,             write: AsString
        required :username,        write: AsString
        required :password,        write: AsString

        optional :target,          write: AsString,  default: proc { DEFAULT_TARGET }
        optional :team,            write: AsString,  default: proc { DEFAULT_TEAM }
        optional :debug,           write: AsBoolean, default: proc { DEFAULT_DEBUG }
        optional :insecure,        write: AsBoolean, default: proc { DEFAULT_INSECURE }
        optional :multiline_lines, write: AsBoolean, default: proc { DEFAULT_MULTILINE_LINES }
        optional :secure_output,   write: AsBoolean, default: proc { DEFAULT_SECURE_OUTPUT }
      end

      class OutParams < Object
        optional :options,      write: AsString
        optional :options_file, write: AsString
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "fly"))
      end
    end
  end
end
