# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class AnsiblePlaybook < Resource
      RESOURCE_NAME     = "ansible-playbook"
      GITHUB_OWNER      = "troykinsella"
      GITHUB_REPOSITORY = "troykinsella/concourse-ansible-playbook-resource"
      GITHUB_VERSION    = "1.0.0"

      class Source < Object
        DEFAULT_DEBUG                     = false
        DEFAULT_GIT_SKIP_SSL_VERIFICATION = false
        DEFAULT_REQUIREMENTS              = "requirements.yml"

        required :ssh_private_key

        optional :env,                       write: AsHashOf.(:to_s, :to_s), default: EmptyHash
        optional :git_global_config,         write: AsHash,                  default: EmptyHash
        optional :debug,                     write: AsBoolean,               default: proc { DEFAULT_DEBUG }
        optional :git_skip_ssl_verification, write: AsBoolean,               default: proc { DEFAULT_GIT_SKIP_SSL_VERIFICATION }
        optional :requirements,              write: AsString,                default: proc { DEFAULT_REQUIREMENTS }
        optional :git_https_username,        write: AsString
        optional :git_https_password,        write: AsString
        optional :git_private_key,           write: AsString
        optional :user,                      write: AsString
        optional :ssh_common_args,           write: AsString
        optional :vault_password,            write: AsString
        optional :verbose,                   write: AsString
      end

      class OutParams < Object
        DEFAULT_BECOME   = false
        DEFAULT_CHECK    = false
        DEFAULT_DIFF     = false
        DEFAULT_PLAYBOOK = "site.yml"

        required :inventory,     write: AsString
        required :path,          write: AsString

        optional :vars,          write: AsHash,    default: EmptyHash
        optional :diff,          write: AsBoolean, default: proc { DEFAULT_DIFF }
        optional :become,        write: AsBoolean, default: proc { DEFAULT_BECOME }
        optional :playbook,      write: AsString,  default: proc { DEFAULT_PLAYBOOK }
        optional :become_user,   write: AsString
        optional :become_method, write: AsString
        optional :vars_file,     write: AsString

        def initialize(options = {})
          super(options) do |this, options|
            raise KeyError, "#{self.class.inspect} requires one of (vars, vars_file), not both" if (this.vars? and this.vars_file?)

            yield this, options if block_given?
          end
        end
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "ansible-playbook"))
      end
    end
  end
end
