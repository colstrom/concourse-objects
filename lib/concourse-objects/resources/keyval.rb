# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class KeyVal < Resource
      RESOURCE_NAME     = "keyval"
      RESOURCE_LICENSE  = "Apache-2.0"
      GITHUB_OWNER      = "SWCE"
      GITHUB_REPOSITORY = "SWCE/keyval-resource"
      GITHUB_VERSION    = "1.0.6"

      class Source < Object
      end

      class OutParams < Object
        required :file, write: AsString
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "keyval"))
      end
    end
  end
end
