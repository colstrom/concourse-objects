# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class BoshIOStemcell < Resource
      RESOURCE_NAME     = "bosh-io-stemcell"
      GITHUB_OWNER      = "concourse"
      GITHUB_REPOSITORY = "concourse/bosh-io-stemcell-resource"
      GITHUB_VERSION    = "v1.0.3"

      class Source < Object
        required :name, write: AsString

        optional :version_family, write: AsString,  default: proc { DEFAULT_VERSION_FAMILY }
        optional :force_regular,  write: AsBoolean, default: proc { DEFAULT_FORCE_REGULAR }
      end

      class InParams < Object
        DEFAULT_TARBALL           = true
        DEFAULT_PRESERVE_FILENAME = false

        optional :tarball,           write: AsBoolean, default: proc { DEFAULT_TARBALL }
        optional :preserve_filename, write: AsBoolean, default: proc { DEFAULT_PRESERVE_FILENAME }
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "bosh-io-stemcell")) do |this, options|
          yield this, options if block_given?
        end
      end
    end
  end
end
