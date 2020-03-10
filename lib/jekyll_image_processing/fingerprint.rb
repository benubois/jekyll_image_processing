require "digest"

module Jekyll
  module JekyllImageProcessing
    class Fingerprint
      attr_reader :file, :options
      def initialize(file, options)
        @file = file
        @options = options
      end

      def basename
        File.basename(file)
      end

      def fingerprint
        Digest::SHA1.hexdigest(options.to_s)[0..5]
      end

      def basename
        File.basename(file, ".*")
      end

      def extension
        File.extname(file)
      end

      def to_s
        parts = []
        parts.push(basename)
        parts.push("-")
        parts.push(fingerprint)
        parts.push(extension)
        parts.join
      end
    end
  end
end
