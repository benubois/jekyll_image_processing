require "digest"

module Jekyll
  module JekyllImageProcessing
    class Options
      RESERVED_KEYS = ["destination", "source"]

      attr_reader :options, :file

      def initialize(file, options)
        @file = file
        @options = options
      end

      def destination
        options.fetch("destination")
      end

      def source
        options.fetch("source")
      end

      def file_name
        Fingerprint.new(file, options).to_s
      end

      def original_name
        File.basename(file)
      end

      def commands
        processing_commands = options.reject { |key, _| RESERVED_KEYS.include?(key) }
        JSON.parse(JSON[processing_commands], symbolize_names: true)
      end
    end
  end
end
