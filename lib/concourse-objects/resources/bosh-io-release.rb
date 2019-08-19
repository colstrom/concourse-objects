# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class BoshIORelease < Resource
      RESOURCE_NAME     = "bosh-io-release"
      GITHUB_OWNER      = "concourse"
      GITHUB_REPOSITORY = "concourse/bosh-io-release-resource"
      GITHUB_VERSION    = "v1.0.2"

      class Source < Object
        required :repository, write: AsString

        optional :regexp,     write: AsString
      end

      class InParams <  Object
        DEFAULT_TARBALL = true

        optional :tarball, write: AsBoolean, default: proc { DEFAULT_TARBALL }
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "bosh-io-release")) do |this, options|
          yield this, options if block_given?
        end
      end
    end
  end
end
