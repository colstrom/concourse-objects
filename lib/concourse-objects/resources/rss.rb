# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class RSS < Resource
      RESOURCE_NAME     = "rss"
      RESOURCE_LICENSE  = "MIT"
      GITHUB_OWNER      = "suhlig"
      GITHUB_REPOSITORY = "suhlig/concourse-rss-resource"
      GITHUB_VERSION    = "v1.0"

      class Source < Object
        required :uri, write: AsString
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "rss"))
      end
    end
  end
end
