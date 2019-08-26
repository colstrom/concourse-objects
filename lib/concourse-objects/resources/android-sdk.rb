# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class AndroidSDK < Resource
      RESOURCE_NAME     = "android-sdk"
      GITHUB_OWNER      = "xaethos"
      GITHUB_REPOSITORY = "xaethos/android-sdk-resource"
      GITHUB_VERSION    = "v0.2"

      class Source < Object
        DEFAULT_COMPONENTS = ["platform-tools"]

        required :components, write: AsArrayOf.(:to_s), default: proc { DEFAULT_COMPONENTS }
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "android-sdk"))
      end
    end
  end
end
