# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class BOSHRelease < Resource
      RESOURCE_NAME     = "bosh-release"
      GITHUB_OWNER      = "dpb587"
      GITHUB_REPOSITORY = "dpb587/bosh-release-resource"
      GITHUB_VERSION    = "v0.4.0"

      class Source < Object
        required :uri,            write: AsString

        optional :branch,         write: AsString
        optional :name,           write: AsString
        optional :version,        write: AsString
        optional :dev_releases,   write: AsBoolean
        optional :private_config, write: AsHash,   default: EmptyHash
      end

      class InParams < Object
        DEFAULT_TARBALL      = true
        DEFAULT_TARBALL_NAME = "{{.Name}}-{{.Version}}.tgz"

        optional :tarball_name, write: AsString
        optional :tarball,      write: AsBoolean, default: proc { DEFAULT_TARBALL }
      end

      class OutParams < Object
        DEFAULT_AUTHOR_NAME  = "CI Bot"
        DEFAULT_AUTHOR_EMAIL = "ci@localhost"
        DEFAULT_REBASE       = false
        DEFAULT_SKIP_TAG     = false

        required :version,      write: AsString

        optional :repository,   write: AsString
        optional :tarball,      write: AsString
        optional :commit_file,  write: AsString
        optional :author_name,  write: AsString,  default: proc { DEFAULT_AUTHOR_NAME }
        optional :author_email, write: AsString,  default: proc { DEFAULT_AUTHOR_EMAIL }
        optional :rebase,       write: AsBoolean, default: proc { DEFAULT_REBASE }
        optional :skip_tag,     write: AsBoolean, default: proc { DEFAULT_SKIP_TAG }

        def initialize(options = {})
          super(options) do |this, options|
            raise KeyError, "#{self.class.inspect} requires one of (repository, tarball)" unless (this.repository? or this.tarball?)

            yield this, options if block_given?
          end
        end
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "bosh-release"))
      end
    end
  end
end
