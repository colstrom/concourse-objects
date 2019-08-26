# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class Kubernetes < Resource
      RESOURCE_NAME     = "kubernetes"
      RESOURCE_LICENSE  = "MIT"
      GITHUB_OWNER      = "zlabjp"
      GITHUB_REPOSITORY = "zlabjp/kubernetes-resource"
      GITHUB_VERSION    = "v1.8.1"

      class Source < Object
        DEFAULT_INSECURE_SKIP_TLS_VERIFY  = false
        DEFAULT_USE_AWS_IAM_AUTHENTICATOR = false

        optional :kubeconfig,                 write: AsString
        optional :context,                    write: AsString
        optional :server,                     write: AsString
        optional :token,                      write: AsString
        optional :namespace,                  write: AsString
        optional :certificate_authority,      write: AsString
        optional :certificate_authority_file, write: AsString
        optional :insecure_skip_tls_verify,   write: AsBoolean, default: proc { DEFAULT_INSECURE_SKIP_TLS_VERIFY }
        optional :use_aws_iam_authenticator,  write: AsBoolean, default: proc { DEFAULT_USE_AWS_IAM_AUTHENTICATOR }
        optional :aws_eks_cluster_name,       write: AsString
        optional :aws_eks_assume_role,        write: AsString
        optional :aws_access_key_id,          write: AsString
        optional :aws_secret_access_key,      write: AsString
        optional :aws_session_tolen,          write: AsString
      end

      class OutParams < Object
        DEFAULT_WAIT_UNTIL_READY    = 30
        DEFAULT_WAIT_READY_INTERVAL = 3
        
        required :kubectl,                   write: AsString

        optional :wait_until_ready,          write: AsInteger, default: proc { DEFAULT_WAIT_READY }
        optional :wait_until_ready_interval, write: AsInteger, default: proc { DEFAULT_WAIT_READY_INTERVAL }
        optional :wait_until_ready_selector, write: AsString
        optional :kubeconfig_file,           write: AsString
        optional :namespace,                 write: AsString
        optional :context,                   write: AsString
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "kubernetes"))
      end
    end
  end
end
