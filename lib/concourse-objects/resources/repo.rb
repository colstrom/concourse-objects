# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Repo < Resource
      RESOURCE_NAME     = "repo"
      GITHUB_OWNER      = "google"
      GITHUB_REPOSITORY = "google/concourse-resources"
      GITHUB_VERSION    = "0.2.2"

      class Source < Object
        required :manifest_url,    write: AsString

        optional :manifest_name,   write: AsString
        optional :manifest_branch, write: AsString
        optional :groups,          write: AsArrayOf.(:to_s), default: EmptyArray
        optional :init_options,    write: AsHash,            default: EmptyHash
        optional :sync_options,    write: AsHash,            default: EmptyHash
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "repo"))
      end
    end
  end
end
