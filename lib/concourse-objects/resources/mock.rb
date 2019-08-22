# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Mock < Resource
      RESOURCE_NAME     = "mock"
      GITHUB_OWNER      = "concourse"
      GITHUB_REPOSITORY = "concourse/mock-resource"
      GITHUB_VERSION    = "v0.6.1"

      class Source < Object
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "mock"))
      end
    end
  end
end
