# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class ArtifactoryDeb < Resource
      RESOURCE_NAME     = "artifactory-deb"
      RESOURCE_LICENSE  = "MIT"
      GITHUB_OWNER      = "troykinsella"
      GITHUB_REPOSITORY = "troykinsella/concourse-artifactory-deb-resource"
      GITHUB_VERSION    = "1.0.0"

      class Source < Object
        DEFAULT_ARCHITECTURE   = "amd64"
        DEFAULT_COMPONENT      = "main"
        DEFAULT_COMPONENTS_DIR = "pool"
        DEFAULT_TRUSTED        = false

        required :distribution,    write: AsString
        required :package,         write: AsString
        required :password,        write: AsString
        required :repostory,       write: AsString
        required :username,        write: AsString

        optional :apt_keys,        write: AsArrayOf.(:to_s), default: EmptyArray
        optional :other_sources,   write: AsArrayOf.(:to_s), default: EmptyArray
        optional :trusted,         write: AsBoolean,         default: proc { DEFAULT_TRUSTED }
        optional :architecture,    write: AsString,          default: proc { DEFAULT_ARCHITECTURE }
        optional :component,       write: AsString,          default: proc { DEFAULT_COMPONENT }
        optional :components_dir,  write: AsString,          default: proc { DEFAULT_COMPONENTS_DIR }
        optional :version_pattern, write: AsString
      end

      class InParams < Object
        DEFAULT_FETCH_ARCHIVES = false

        optional :fetch_archives, write: AsBoolean, default: proc { DEFAULT_FETCH_ARCHIVES }
      end

      class OutParams < Object
        required :debs,        write: AsString

        optional :deb_pattern, write: AsString
      end
      
      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "artifactory-deb"))
      end
    end
  end
end
