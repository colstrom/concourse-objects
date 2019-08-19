# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class SemVer < Resource
      RESOURCE_NAME     = "semver"
      GITHUB_OWNER      = "concourse"
      GITHUB_REPOSITORY = "concourse/semver-resource"
      GITHUB_VERSION    = "v1.0.2"

      class Source < Object
        DEFAULT_DRIVER     = "s3"
        ACCEPTABLE_DRIVERS = ["git", "s3", "swift", "gcs"]
        DriverIsAcceptable = proc { |_, driver| ACCEPTABLE_DRIVERS.include?(driver) }

        optional :initial_version, write: AsString
        optional :driver,          write: AsString, guard: DriverIsAcceptable

        class Git < Source
          DEFAULT_SKIP_SSL_VERIFICATION = false

          ValueIsPositive = proc { |_, value| value.positive? }

          required :uri,                   write: AsString
          required :branch,                write: AsString
          required :file,                  write: AsString

          optional :depth,                 write: AsInteger,                                                 guard: ValueIsPositive
          optional :skip_ssl_verification, write: AsBoolean, default: proc { DEFAULT_SKIP_SSL_VERIFICATION }
          optional :private_key,           write: AsString
          optional :username,              write: AsString
          optional :password,              write: AsString
          optional :git_user,              write: AsString
          optional :commit_message,        write: AsString

          def initialize(options = {})
            super(options.merge(driver: "git")) do |this, options|
              yield this, options if block_given?
            end
          end
        end

        class S3 < Source
          DEFAULT_USE_V2_SIGNING        = false
          DEFAULT_DISABLE_SSL           = false
          DEFAULT_SKIP_SSL_VERIFICATION = false
          DEFAULT_REGION_NAME           = "us-east-1"

          required :bucket,                 write: AsString
          required :key,                    write: AsString
          required :access_key_id,          write: AsString
          required :secret_access_key,      write: AsString

          optional :disable_ssl,            write: AsBoolean, default: proc { DEFAULT_DISABLE_SSL }
          optional :skip_ssl_verification,  write: AsBoolean, default: proc { DEFAULT_SKIP_SSL_VERIFICATION }
          optional :use_v2_signing,         write: AsBoolean, default: proc { DEFAULT_USE_V2_SIGNING }
          optional :region_name,            write: AsString,  default: proc { DEFAULT_REGION_NAME }
          optional :endpoint,               write: AsString
          optional :server_side_encryption, write: AsString

          def initialize(options = {})
            super(options.merge(driver: "s3")) do |this, options|
              yield this, options if block_given?
            end
          end
        end

        class Swift < Source
          class OpenStack < Object
            DEFAULT_ALLOW_REAUTH = false

            required :container,         write: AsString
            required :item_name,         write: AsString
            required :region,            write: AsString

            optional :allow_reauth,      write: AsBoolean, default: proc { DEFAULT_ALLOW_REAUTH }
            optional :identity_endpoint, write: AsString
            optional :username,          write: AsString
            optional :user_id,           write: AsString
            optional :password,          write: AsString
            optional :api_key,           write: AsString
            optional :domain_id,         write: AsString
            optional :tenant_id,         write: AsString
            optional :tenant_name,       write: AsString
            optional :token_id,          write: AsString
          end

          required :openstack, write: OpenStack

          def initialize(options = {})
            super(options.merge(driver: "swift")) do |this, options|
              yield this, options if block_given?
            end
          end
        end

        class GCS < Source
          required :bucket,   write: AsString
          required :key,      write: AsString
          required :json_key, write: AsString

          def initialize(options = {})
            super(options.merge(driver: "gcs")) do |this, options|
              yield this, options if block_given?
            end
          end
        end
      end

      optional :source, write: Source, default: proc { Source.new }

      def initialize(options = {})
        super(options.merge(type: "semver")) do |this, options|
          if this.source?
            options.fetch(:source).yield_self do |source|
              case this.source.driver
              when "git"   then Source::Git.(source)
              when "s3"    then Source::S3.(source)
              when "swift" then Source::Swift.(source)
              when "gcs"   then Source::GCS.(source)
              else Source.(source)
              end.yield_self do |source|
                this.send(:instance_variable_set, :@source, source)
              end
            end
          end

          yield this, options if block_given?
        end
      end
    end
  end
end
