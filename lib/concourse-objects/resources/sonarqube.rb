# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class SonarQube < Resource
      RESOURCE_NAME     = "sonarqube"
      RESOURCE_LICENSE  = "Apache-2.0"
      GITHUB_OWNER      = "cathive"
      GITHUB_REPOSITORY = "cathive/concourse-sonarqube-resource"
      GITHUB_VERSION    = "0.9.1"

      class Source < Object
        required :host_url,       write: AsString

        optional :organization,   write: AsString
        optional :login,          write: AsString
        optional :password,       write: AsString
        optional :__debug,        write: AsBoolean
        optional :maven_settings
      end

      class InParams < Object
        class QualityGate < Object
          DEFAULT_IGNORE_ALL_WARN  = false
          DEFUALT_IGNORE_ALL_ERROR = false

          optional :ignore_all_warn,  write: AsBoolean,         default: proc { DEFAULT_IGNORE_ALL_WARN }
          optional :ignore_all_error, write: AsBoolean,         default: proc { DEFAULT_IGNORE_ALL_ERROR }
          optional :ignore_warns,     write: AsArrayOf.(:to_s)
          optional :ignore_errors,    write: AsArrayOf.(:to_s)
        end

        optional :quality_gate, write: QualityGate
      end
      class OutParams < Object
        DEFAULT_SCANNER_TYPE = "auto"
        ACCEPTABLE_SCANNER_TYPES = ["auto", "cli", "maven"]
        ScannerTypeIsAcceptable  = proc { |_, scanner_type| ACCEPTABLE_SCANNER_TYPES.include?(scanner_type) }

        required :project_path,               write: AsString

        optional :sources,                    write: AsArrayOf.(:to_s), default: EmptyArray
        optional :tests,                      write: AsArrayOf.(:to_s), default: EmptyArray
        optional :autodetect_branch_name,     write: AsBoolean,         default: proc { DEFAULT_AUTODETECT_BRANCH_NAME }
        optional :scanner_type,               write: AsString,          default: proc { DEFAULT_SCANNER_TYPE },           guard: ScannerTypeIsAcceptable
        optional :project_key,                write: AsString
        optional :project_key_file,           write: AsString
        optional :project_name,               write: AsString
        optional :project_description,        write: AsString
        optional :project_version,            write: AsString
        optional :project_version_file,       write: AsString
        optional :branch_name,                write: AsString
        optional :branch_target,              write: AsString
        optional :maven_settings_file,        write: AsString
        optional :sonar_maven_plugin_version, write: AsString
        optional :additional_properties_file, write: AsString
        optional :additional_properties,      write: AsHash

      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "sonarqube"))
      end
    end
  end
end
