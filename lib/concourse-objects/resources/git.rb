# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Git < Resource
      RESOURCE_NAME     = "git"
      GITHUB_OWNER      = "concourse"
      GITHUB_REPOSITORY = "concourse/git-resource"
      GITHUB_VERSION    = "v1.5.0"

      class Source < Object
        class HTTPSTunnel < Object
          required :proxy_host, write: AsString
          required :proxy_port, write: AsInteger

          optional :proxy_user,     write: AsString
          optional :proxy_password, write: AsString
        end

        class CommitFilter < Object
          optional :exclude, write: AsArrayOf.(:to_s)
          optional :include, write: AsArrayOf.(:to_s)
        end

        DEFAULT_FORWARD_AGENT         = false
        DEFAULT_SKIP_SSL_VERIFICATION = false
        DEFAULT_DISABLE_CI_SKIP       = false
        DEFAULT_GPG_KEYSERVER         = "hkp://keys.gnupg.net/".freeze

        required :uri,                         write: AsString

        optional :branch,                      write: AsString
        optional :private_key,                 write: AsString
        optional :username,                    write: AsString
        optional :password,                    write: AsString
        optional :tag_filter,                  write: AsString
        optional :git_crypt_key,               write: AsString
        optional :gpg_keyserver,               write: AsString,                default: proc { DEFAULT_GPG_KEYSERVER }
        optional :forward_agent,               write: AsBoolean,               default: proc { DEFAULT_FORWARD_AGENT }
        optional :skip_ssl_verification,       write: AsBoolean,               default: proc { DEFAULT_SKIP_SSL_VERIFICATION }
        optional :disable_ci_skip,             write: AsBoolean,               default: proc { DEFAULT_DISABLE_CI_SKIP }
        optional :paths,                       write: AsArrayOf.(:to_s),       default: EmptyArray
        optional :ignore_paths,                write: AsArrayOf.(:to_s),       default: EmptyArray
        optional :commit_verification_keys,    write: AsArrayOf.(:to_s),       default: EmptyArray
        optional :commit_verification_key_ids, write: AsArrayOf.(:to_s),       default: EmptyArray
        optional :git_config,                  write: AsHashOf.(:to_s, :to_s), default: EmptyHash
        optional :https_tunnel,                write: HTTPSTunnel
        optional :commit_filter,               write: CommitFilter
      end

      class InParams < Object
        DEFAULT_SUBMODULE_RECURSIVE = true
        DEFAULT_SUBMODULE_REMOTE    = false
        DEFAULT_DISABLE_GIT_LFS     = false
        DEFAULT_CLEAN_TAGS          = false
        DEFAULT_SHORT_REF_FORMAT    = "%s"
        ACCEPTABLE_SUBMODULES       = ["none", "all", Array]

        SubmodulesAreAcceptable = proc { |_, submodules| ACCEPTABLE_SUBMODULES.any? { |as| as === submodules } }
        ValueIsPositive         = proc { |_, value| value.positive? }

        optional :depth,               write: AsInteger,                                               guard: ValueIsPositive
        optional :submodules,                                                                          guard: SubmodulesAreAcceptable
        optional :submodule_recursive, write: AsBoolean, default: proc { DEFAULT_SUBMODULE_RECURSIVE }
        optional :submodule_remote,    write: AsBoolean, default: proc { DEFAULT_SUBMODULE_REMOTE }
        optional :disable_git_lfs,     write: AsBoolean, default: proc { DEFAULT_DISABLE_GIT_LFS }
        optional :clean_tags,          write: AsBoolean, default: proc { DEFAULT_CLEAN_TAGS }
        optional :short_ref_format,    write: AsString,  default: proc { DEFAULT_SHORT_REF_FORMAT }
      end

      class OutParams < Object
        DEFAULT_REBASE       = false
        DEFAULT_MERGE        = false
        DEFAULT_ONLY_TAG     = false
        DEFAULT_FORCE        = false
        DEFAULT_RETURNING    = "merged"
        ACCEPTABLE_RETURNING = ["merged", "unmerged"]

        ReturningIsAcceptable =  proc { |params, returning| params.merge and ACCEPTABLE_RETURNING.include?(returning) }

        required :repository, write: AsString

        optional :rebase,     write: AsBoolean, default: proc { DEFAULT_REBASE }
        optional :merge,      write: AsBoolean, default: proc { DEFAULT_MERGE }
        optional :returning,  write: AsString,  default: proc { DEFAULT_RETURNING }, guard: ReturningIsAcceptable
        optional :tag,        write: AsString
        optional :only_tag,   write: AsBoolean, default: proc { DEFAULT_ONLY_TAG }
        optional :tag_prefix, write: AsString
        optional :force,      write: AsBoolean, default: proc { DEAULT_FORCE }
        optional :annotate,   write: AsString
        optional :notes,      write: AsString

        def initialize(options = {})
          super(options)
          super(options) do |this, options|
            raise KeyError, "expected one of (rebase || merge), got both" if [:rebase, :merge].all? { |key| options.key?(key) }
            yield this, options if block_given?
          end
        end
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "git"))
      end
    end
  end
end
