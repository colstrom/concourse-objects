# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Artifactory < Resource
      RESOURCE_NAME     = "artifactory"
      RESOURCE_LICENSE  = "MIT"
      GITHUB_OWNER      = "troykinsella"
      GITHUB_REPOSITORY = "troykinsella/concourse-artifactory-resource"
      GITHUB_VERSION    = "1.0.0"

      class Source < Object
        required :repository, write: AsString
        required :api_key,    write: AsString

        optional :path,       write: AsString
      end

      class OutParams < Object
        optional :files, write: AsString
        optional :flob,  write: AsString
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "artifactory"))
      end
    end
  end
end
