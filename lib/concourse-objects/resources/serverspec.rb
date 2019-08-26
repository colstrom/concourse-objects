# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class ServerSpec < Resource
      RESOURCE_NAME     = "serverspec"
      RESOURCE_LICENSE  = nil
      GITHUB_OWNER      = "opicaud"
      GITHUB_REPOSITORY = "opicaud/serverspec-resource"
      GITHUB_VERSION    = "0.0.2"

      class Source < Object
        optional :ssh_key, write: AsString
      end

      class InParams < Object
        optional :tests,     write: AsString
        optional :inventory, write: AsString
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "mock"))
      end
    end
  end
end
