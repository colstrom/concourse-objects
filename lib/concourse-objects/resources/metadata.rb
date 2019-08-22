# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Metadata < Resource
      RESOURCE_NAME     = "metadata"
      GITHUB_OWNER      = "SWCE"
      GITHUB_REPOSITORY = "SWCE/metadata-resource"
      GITHUB_VERSION    = "v0.0.3"

      class Source < Object
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "metadata"))
      end
    end
  end
end
