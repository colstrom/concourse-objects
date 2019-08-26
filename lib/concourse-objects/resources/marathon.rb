# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Marathon < Resource
      RESOURCE_NAME     = "marathon"
      GITHUB_OWNER      = "ckaznocha"
      GITHUB_REPOSITORY = "ckaznocha/marathon-resource"
      GITHUB_VERSION    = "0.4.0"

      class Source < Object
        class BasicAuth < Object
          required :user_name, write: AsString
          required :password,  write: AsString
        end

        required :app_id, write: AsString
        required :uri,    write: AsString

        optional :basic_auth, write: BasicAuth
        optional :api_token,  write: AsString
      end

      class OutParams < Object
        DEFAULT_RESTART_IF_NO_UPDATE = false
        
        required :app_json,             write: AsString
        required :time_out,             write: AsInteger

        optional :restart_if_no_update, write: AsBoolean,               default: proc { DEFAULT_RESTART_IF_NO_UPDATE }
        optional :replacements,         write: AsHashOf.(:to_s, :to_s), default: EmptyHash
        optional :replacement_files,    write: AsString
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "marathon"))
      end
    end
  end
end
