# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class RegistryImage < Resource
      RESOURCE_NAME     = "registry-image"
      RESOURCE_LICENSE  = "Apache-2.0"
      GITHUB_OWNER      = "concourse"
      GITHUB_REPOSITORY = "concourse/registry-image-resource"
      GITHUB_VERSION    = "v0.6.1"

      class Source < Object
        DEFAULT_DEBUG = false
        DEFAULT_TAG   = "latest"

        required :repository, write: AsString

        optional :username,   write: AsString
        optional :password,   write: AsString
        optional :tag,        write: AsString,  default: proc { DEFAULT_TAG }
        optional :debug,      write: AsBoolean, default: proc { DEFAULT_DEBUG }
      end

      class InParams < Object
        DEFAULT_FORMAT     = "rootfs"
        ACCEPTABLE_FORMATS = ["rootfs", "oci"]

        FormatIsAcceptable = proc { |_, format| ACCEPTABLE_FORMATS.include?(format) }

        optional :format, write: AsString, default: proc { DEFAULT_FORMAT }, guard: FormatIsAcceptable
      end

      class OutParams < Object
        required :image,           write: AsString

        optional :additional_tags, write: AsArrayOf.(:to_s), default: EmptyArray
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "registry-image")) do |this, options|
          yield this, options if block_given?
        end
      end
    end
  end
end
