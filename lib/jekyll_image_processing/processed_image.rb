require "image_processing/vips"
require "zlib"

module Jekyll
  module JekyllImageProcessing
    class ProcessedImage < Jekyll::StaticFile
      attr_accessor :image_processing_options

      def path
        File.join(@base, @dir.sub(image_processing_options.destination, image_processing_options.source), image_processing_options.original_name)
      end

      def write(dest)
        dest_path = destination(dest)

        return false if File.exist?(dest_path) && !modified?(dest_path)

        Jekyll.logger.debug "JekyllImageProcessing:", File.join(@base, image_processing_options.destination, @name)

        FileUtils.mkdir_p(File.dirname(dest_path))

        ::ImageProcessing::Vips.source(path).apply(image_processing_options.commands).call(destination: dest_path)

        true
      end

      def modified?(path)
        !File.exist?(path)
      end
    end

    class ImageGenerator < Generator
      safe true
      def generate(site)
        return unless site.config["image_processing"]

        site.config["image_processing"].each_pair do |name, preset|
          Dir.glob(File.join(site.source, preset["source"], "*.{png,jpg,jpeg,gif,webp}")) do |file|
            options = JekyllImageProcessing::Options.new(file, preset.clone)
            file = ProcessedImage.new(site, site.source, options.destination, options.file_name, nil)
            file.image_processing_options = options
            site.static_files << file
          end
        end
      end
    end
  end
end
