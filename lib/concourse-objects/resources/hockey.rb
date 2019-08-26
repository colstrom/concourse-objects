# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Hockey < Resource
      RESOURCE_NAME     = "hockey"
      GITHUB_OWNER      = "seadowg"
      GITHUB_REPOSITORY = "seadowg/hockey-resource"
      GITHUB_VERSION    = "0.1.0"

      class Source < Object
        required :app_id, write: AsString
        required :token,  write: AsString
      end

      class OutParams < Object
        required :path,         write: AsString

        optional :downloadable, write: AsBoolean
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "hockey"))
      end
    end
  end
end
