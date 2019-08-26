# frozen_string_literal: true

require_relative "../../concourse-objects"

module ConcourseObjects
  module Resources
    class ChartMuseum < Resource
      RESOURCE_NAME     = "chartmuseum"
      GITHUB_OWNER      = "cathive"
      GITHUB_REPOSITORY = "cathive/concourse-chartmuseum-resource"
      GITHUB_VERSION    = "0.6.0"

      class Source < Object
        required :server_url,          write: AsString
        required :chart_name,          write: AsString
        optional :version_range,       write: AsString
        optional :basic_auth_username, write: AsString
        optional :basic_auth_password, write: AsString
      end

      class InParams < Object
        optional :target_basename, write: AsString
      end

      class OutParams < Object
        DEFAULT_FORCE = false
        DEFAULT_SIGN  = false

        required :chart, write: AsString

        optional :force,        write: AsBoolean, default: proc { DEFAULT_FORCE }
        optional :sign,         write: AsBoolean, default: proc { DEFAULT_SIGN }
        optional :key_data,     write: AsString
        optional :key_file,     write: AsString
        optional :version,      write: AsString
        optional :version_file, write: AsString

        def initialize(options = {})
          super(options)
          super(options) do |this, options|
            raise KeyError, "#{self.class.inspect} requires one of (key_data, key_file)" if this.sign? unless (this.key_data? or this.key_file?)

            yield this, options if block_given?
          end
        end
      end

      optional :source, write: Source

      def initialize(options = {})
        super(options.merge(type: "chartmuseum"))
      end
    end
  end
end
