# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Maven < Resource
      RESOURCE_NAME     = "maven"
      GITHUB_OWNER      = "nulldriver"
      GITHUB_REPOSITORY = "nulldriver/maven-resource"
      GITHUB_VERSION    = "v1.3.6"

      class Source < Object
        DEFAULT_DISABLE_REDEPLOY = false
        DEFAULT_SKIP_CERT_CHECK  = false

        required :url,              write: AsString
        required :artifact,         write: AsString

        optional :snapshot_url,     write: AsString
        optional :username,         write: AsString
        optional :password,         write: AsString
        optional :repository_cert,  write: AsString
        optional :disable_redeploy, write: AsBoolean, default: proc { DEFAULT_DISABLE_REDEPLOY }
        optional :skip_cert_check,  write: AsBoolean, default: proc { DEFAULT_SKIP_CERT_CHECK }
      end

      class OutParams < Object
        required :file,         write: AsString
        required :version_file, write: AsString

        optional :pom_file,     write: AsString
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "maven"))
      end
    end
  end
end
