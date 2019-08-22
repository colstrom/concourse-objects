# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class RubyGems < Resource
      RESOURCE_NAME     = "rubygems"
      GITHUB_OWNER      = "troykinsella"
      GITHUB_REPOSITORY = "troykinsella/concourse-rubygems-resource"
      GITHUB_VERSION    = "1.0.0"

      class Source < Object
        DEFAULT_PRERELEASE = false
        DEFAULT_SOURCE_URL = "https://rubygems.org"

        required :gem_name, write: AsString

        optional :apt_keys,     write: AsArrayOf.(:to_s)
        optional :apt_sources,  write: AsArrayOf.(:to_s)
        optional :deb_packages, write: AsArrayOf.(:to_s)
        optional :credentials,  write: AsString
        optional :source_url,   write: AsString,         default: proc { DEFAULT_SOURCE_URL }
      end

      class InParams < Object
        DEFAULT_SKIP_DOWNLOAD = false

        optional :install_options, write: AsArrayOf.(:to_s)
        optional :skip_download,   write: AsBoolean,        default: proc { DEFAULT_SKIP_DOWNLOAD }
      end

      class OutParams < Object
        required :gem_dir,   write: AsString
        optional :gem_regex, write: AsString
        optional :key_name,  write: AsString
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "mock"))
      end
    end
  end
end
