# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class DevPI < Resource
      RESOURCE_NAME     = "devpi"
      GITHUB_OWNER      = "mdomke"
      GITHUB_REPOSITORY = "mdomke/devpi-resource"
      GITHUB_VERSION    = "1.1.1"

      class Source < Object
        ACCEPTABLE_VERSIONINGS = ["loose", "semantic"]
        DEFAULT_VERSIONING     = "loose"
        VersioningIsAcceptable = proc { |_, versioning| ACCEPTABLE_VERSIONINGS.include?(versioning) }

        required :uri,        write: AsString
        required :index,      write: AsString
        required :package,    write: AsString

        optional :username,   write: AsString
        optional :password,   write: AsString
        optional :versioning, write: AsString, default: proc { DEFAULT_VERSIONING }, guard: VersioningIsAcceptable
      end

      class InParams < Object
        optional :version, write: AsString
      end

      class OutParams < Object
        optional :file,     write: AsString
        optional :fileglob, write: AsString
      end
      
      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "devpi"))
      end
    end
  end
end
