# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class CFZeroDowntime < Resource
      RESOURCE_NAME     = "cf-zero-downtime"
      RESOURCE_LICENSE  = "MIT"
      GITHUB_OWNER      = "emerald-squad"
      GITHUB_REPOSITORY = "emerald-squad/cf-zero-downtime-resource"
      GITHUB_VERSION    = "0.1.0"

      class Source < Object
        DEFAULT_SKIP_CERT_CHECK = false
        DEFAULT_VERBOSE         = false

        required :api,             write: AsString
        required :organization,    write: AsString
        required :space,           write: AsString

        optional :username,        write: AsString
        optional :password,        write: AsString
        optional :client_id,       write: AsString
        optional :client_secret,   write: AsString
        optional :skip_cert_check, write: AsBoolean, default: proc { DEFAULT_SKIP_CERT_CHECK }
        optional :verbose,         write: AsBoolean, default: proc { DEFAULT_VERBOSE }

        def initialize(options = {})
          super(options) do |this, options|
            raise KeyError, "#{self.class.inspect} requires one of ((username, password), (client_id, client_secret))" unless ((this.username? and this.password?) or (this.client_id? and this.client_secret?))

            yield this, options if block_given?
          end
        end
      end

      class OutParams < Object
        class Service < Object
          required :name,   write: AsString
          required :config, write: AsHash
        end

        required :name,     write: AsString
        required :manifest, write: AsString
        required :path,     write: AsString

        optional :environment_variables, write: AsHashOf.(:to_s, :to_s), default: EmptyHash
        optional :manifest,              write: AsHash,                  default: EmptyHash
        optional :manifest_vars,         write: AsHash,                  default: EmptyHash
        optional :manifest_vars_files,   write: AsArrayOf.(:to_s),       default: EmptyArray
        optional :services,              write: AsArrayOf.(Service),     default: EmptyArray
        optional :docker_username,       write: AsString
        optional :docker_password,       write: AsString
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "cf-zero-downtime"))
      end
    end
  end
end
