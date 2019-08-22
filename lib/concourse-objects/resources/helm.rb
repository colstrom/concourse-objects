# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Helm < Resource
      RESOURCE_NAME     = "helm"
      GITHUB_OWNER      = "linkyard"
      GITHUB_REPOSITORY = "linkyard/concourse-helm-resource"
      GITHUB_VERSION    = "2.14.1-1"

      class Source < Object
        class Plugin < Object
          required :url,     write: AsString

          optional :version, write: AsString
        end

        class Repo < Object
          required :name, write: AsString
          required :url,  write: AsString

          optional :username, write: AsString
          optional :password, write: AsString
        end

        DEFAULT_HELM_INIT_SERVER            = false
        DEFAULT_HELM_INIT_WAIT              = false
        DEFAULT_HELM_LIBRARY_MAX            = 0
        DEFAULT_HELM_SETUP_PURGE_ALL        = false
        DEFAULT_KUBECONFIG_NAMESPACE        = false
        DEFAULT_KUBECONFIG_TILLER_NAMESPACE = false
        DEFAULT_NAMESPACE                   = "default"
        DEFAULT_TILLER_NAMESPACE            = "kube-system"
        DEFAULT_TILLERLESS                  = false
        DEFAULT_TLS_ENABLED                 = false
        DEFAULT_TRACING_ENABLED             = false

        optional :repos,                       write: AsArrayOf.(Repo)
        optional :plugins,                     write: AsArrayOf.(Plugin)
        optional :admin_cert,                  write: AsString
        optional :admin_key,                   write: AsString
        optional :cluster_ca,                  write: AsString
        optional :cluster_url,                 write: AsString
        optional :helm_ca,                     write: AsString
        optional :helm_cert,                   write: AsString
        optional :helm_host,                   write: AsString
        optional :helm_key,                    write: AsString
        optional :release,                     write: AsString
        optional :stable_repo,                 write: AsString
        optional :tiller_cert,                 write: AsString
        optional :tiller_key,                  write: AsString
        optional :tiller_service_account,      write: AsString
        optional :token,                       write: AsString
        optional :token_path,                  write: AsString
        optional :namespace,                   write: AsString,          default: proc { DEFAULT_NAMESPACE }
        optional :tiller_namespace,            write: AsString,          default: proc { DEFAULT_TILLER_NAMESPACE }
        optional :helm_history_max,            write: AsInteger,         default: proc { DEFAULT_HELM_LIBRARY_MAX }
        optional :helm_init_server,            write: AsBoolean,         default: proc { DEFAULT_HELM_INIT_SERVER }
        optional :helm_init_wait,              write: AsBoolean,         default: proc { DEFAULT_HELM_INIT_WAIT }
        optional :helm_setup_purge_all,        write: AsBoolean,         default: proc { DEFAULT_HELM_SETUP_PURGE_ALL }
        optional :kubeconfig_namespace,        write: AsBoolean,         default: proc { DEFAULT_KUBECONFIG_NAMESPACE }
        optional :kubeconfig_tiller_namespace, write: AsBoolean,         default: proc { DEFAULT_KUBECONFIG_TILLER_NAMESPACE }
        optional :tillerless,                  write: AsBoolean,         default: proc { DEFAULT_TILLERLESS }
        optional :tls_enabled,                 write: AsBoolean,         default: proc { DEFAULT_TLS_ENABLED }
        optional :tracing_enabled,             write: AsBoolean,         default: proc { DEFAULT_TRACING_ENABLED }

        def initialize(options = {})
          super(options) do |this, options|
            raise KeyError, "#{self.class.inspect} requires one of (token, token_path, (admin_key, admin_cert))" unless (this.token? or this.token_path? or (this.admin_key? and this.admin_cert?))

            unless this.tls_enabled
              this.tiller_cert = nil
              this.tiller_key  = nil
              this.helm_ca     = nil
              this.helm_cert   = nil
              this.helm_key    = nil
            end

            this.tiller_service_account = nil unless this.helm_init_server

            yield this, options if block_given?
          end
        end
      end

      class OutParams < Object
        DEFAULT_CHECK_IS_READY   = false
        DEFAULT_DEBUG            = false
        DEFAULT_DELETE           = false
        DEFAULT_DEVEL            = false
        DEFAULT_EXIT_AFTER_DIFF  = false
        DEFAULT_FORCE            = false
        DEFAULT_PURGE            = false
        DEFAULT_RECREATE_PODS    = false
        DEFAULT_REPLACE          = false
        DEFAULT_RESET_VALUES     = false
        DEFAULT_REUSE_VALUES     = false
        DEFAULT_SHOW_DIFF        = false
        DEFAULT_TEST             = false
        DEFAULT_WAIT             = 0
        DEFAULT_WAIT_UNTIL_READY = false

        required :chart,            write: AsString

        optional :kubeconfig_path,  write: AsString
        optional :namespace,        write: AsString
        optional :release,          write: AsString
        optional :token_path,       write: AsString
        optional :values,           write: AsString
        optional :version,          write: AsString
        optional :override_values,  write: AsArrayOf.(AsHash), default: EmptyArray
        optional :check_is_ready,   write: AsBoolean,          default: proc { DEFAULT_CHECK_IS_READY }
        optional :debug,            write: AsBoolean,          default: proc { DEFAULT_DEBUG }
        optional :delete,           write: AsBoolean,          default: proc { DEFAULT_DELETE }
        optional :devel,            write: AsBoolean,          default: proc { DEFAULT_DEVEL }
        optional :exit_after_diff,  write: AsBoolean,          default: proc { DEFAULT_EXIT_AFTER_DIFF }
        optional :force,            write: AsBoolean,          default: proc { DEFAULT_FORCE }
        optional :purge,            write: AsBoolean,          default: proc { DEFAULT_PURGE }
        optional :recreate_pods,    write: AsBoolean,          default: proc { DEFAULT_RECREATE_PODS }
        optional :replace,          write: AsBoolean,          default: proc { DEFAULT_REPLACE }
        optional :reset_values,     write: AsBoolean,          default: proc { DEFAULT_RESET_VALUES }
        optional :reuse_values,     write: AsBoolean,          default: proc { DEFAULT_REUSE_VALUES }
        optional :show_diff,        write: AsBoolean,          default: proc { DEFAULT_SHOW_DIFF }
        optional :test,             write: AsBoolean,          default: proc { DEFAULT_TEST }
        optional :wait,             write: AsInteger,          default: proc { DEFAULT_WAIT }
        optional :wait_until_ready, write: AsInteger,          default: proc { DEFAULT_WAIT_UNTIL_READY }
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "helm"))
      end
    end
  end
end
