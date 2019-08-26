# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class CF < Resource
      RESOURCE_NAME     = "cf"
      RESOURCE_LICENSE  = "Apache-2.0"
      GITHUB_OWNER      = "concourse"
      GITHUB_REPOSITORY = "concourse/cf-resource"
      GITHUB_VERSION    = "v1.1.0"

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
      end

      class OutParams < Object
        DEFAULT_SHOW_APP_LOG = false

        HasCurrentAppName = proc { |params| params.current_app_name? }

        required :manifest,              write: AsString

        optional :path,                  write: AsString
        optional :current_app_name,      write: AsString
        optional :docker_username,       write: AsString
        optional :docker_password,       write: AsString
        optional :no_start,              write: AsBoolean,                                                      guard: HasCurrentAppName
        optional :show_app_log,          write: AsBoolean,               default: proc { DEFAULT_SHOW_APP_LOG }
        optional :vars_files,            write: AsArrayOf.(:to_s),       default: EmptyArray
        optional :environment_variables, write: AsHashOf.(:to_s, :to_s), default: EmptyHash
        optional :vars,                  write: AsHash,                  default: EmptyHash
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "cf")) do |this, options|
          yield this, options if block_given?
        end
      end
    end
  end
end
