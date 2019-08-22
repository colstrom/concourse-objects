# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class DockerCompose < Resource
      RESOURCE_NAME     = "docker-compose"
      GITHUB_OWNER      = "troykinsella"
      GITHUB_REPOSITORY = "troykinsella/concourse-docker-compose-resource"
      GITHUB_VERSION    = "1.1.0"

      class Source < Object
        class CACert < Object
          required :domain, write: AsString
          required :domain, write: AsString
        end

        class Registry < Object
          required :host,     write: AsString
          required :username, write: AsString
          required :password, write: AsString
        end

        DEFAULT_PORT    = 2376
        DEFAULT_VERBOSE = false

        required :host,       write: AsString

        optional :port,       write: AsInteger,            default: proc { DEFAULT_PORT }
        optional :verbose,    write: AsBoolean,            default: proc { DEFAULT_VERBOSE }
        optional :ca_certs,   write: AsArrayOf.(CACert),   default: EmptyArray
        optional :registries, write: AsArrayOf.(Registry), default: EmptyArray
      end

      class OutParams < Object
        class Options < Object
          class Up < Options
            DEFAULT_FORCE_RECREATE     = false
            DEFAULT_NO_DEPS            = false
            DEFAULT_NO_RECREATE        = false
            DEFAULT_REMOVE_ORPHANS     = false
            DEFAULT_RENEW_ANON_VOLUMES = false

            optional :scale,                write: AsHashOf.(:to_s, :to_i), default: EmptyHash
            optional :"renew-anon_volumes", write: AsBoolean,               default: proc { DEFAULT_RENEW_ANON_VOLUMES }
            optional :force_recreate,       write: AsBoolean,               default: proc { DEFAULT_FORCE_RECREATE }
            optional :no_deps,              write: AsBoolean,               default: proc { DEFAULT_NO_DEPS }
            optional :no_recreate,          write: AsBoolean,               default: proc { DEFAULT_NO_RECREATE }
            optional :remove_orphans,       write: AsBoolean,               default: proc { DEFAULT_REMOVE_ORPHANS }
            optional :timeout,              write: AsInteger
          end

          class Down < Options
            DEFAULT_VOLUMES        = false
            DEFAULT_REMOVE_ORPHANS = false

            ACCEPTABLE_RMIS = ["all", "local"]
            RMIIsAcceptable = proc { |_, rmi| ACCEPTABLE_RMIS.include?(rmi) }

            optional :volumes,        write: AsBoolean, default: proc { DEFAULT_VOLUMES }
            optional :remove_orphans, write: AsBoolean, default: proc { DEFAULT_REMOVE_ORPHANS }
            optional :rmi,            write: AsString,                                           guard: RMIIsAcceptable
            optional :timeout,        write: AsInteger
          end

          class Start < Options
          end

          class Stop < Options
            optional :timeout, write: AsInteger
          end

          class Restart < Options
            optional :timeout, write: AsInteger
          end

          class Kill < Options
            optional :signal
          end
        end

        DEFAULT_COMMAND      = "up"
        DEFAULT_COMPOSE_FILE = "docker-compose.yml"
        DEFAULT_PRINT        = false
        DEFAULT_PULL         = false

        ACCEPTABLE_COMMANDS  = ["up", "down", "start", "stop", "restart", "kill"]
        CommandIsAcceptable = proc { |_, command| ACCEPTABLE_COMMANDS.include?(command) }

        optional :env,          write: AsHashOf.(:to_s, :to_s), default: EmptyHash
        optional :options,      write: AsHash,                  default: EmptyHash
        optional :services,     write: AsArrayOf.(:to_s),       default: EmptyArray
        optional :print,        write: AsBoolean,               default: proc { DEFAULT_PRINT }
        optional :pull,         write: AsBoolean,               default: proc { DEFAULT_PULL }
        optional :compose_file, write: AsString,                default: proc { DEFAULT_COMPOSE_FILE }
        optional :command,      write: AsString,                default: proc { DEFAULT_COMMAND },     guard: CommandIsAcceptable
        optional :env_file,     write: AsString
        optional :path,         write: AsString
        optional :project,      write: AsString
        optional :wait_before,  write: AsInteger
        optional :wait_after,   write: AsInteger

        def initialize(options = {})
          super(options) do |this, options|
            case this.command
            when "up"      then Options::Up.(options)
            when "down"    then Options::Down.(options)
            when "start"   then Options::Start.(options)
            when "stop"    then Options::Stop.(options)
            when "restart" then Options::Restart.(options)
            when "kill"    then Options::Kill.(options)
            else Options.(options)
            end.yield_self do |options|
              this.send(:instance_variable_set, :@options, options)
            end

            yield this, options if block_given?
          end
        end
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "docker-compose"))
      end
    end
  end
end
