require "jekyll_image_processing/version"
require "image_processing/vips"

module Jekyll
  module JekyllImageProcessing
    class GeneratedImageFile < Jekyll::StaticFile
      attr_accessor :dst_dir, :src_dir, :commands

      def path
        File.join(@base, @dir.sub(dst_dir, src_dir), @name)
      end

      def write(dest)
        dest_path = destination(dest)

        Jekyll.logger.debug "JekyllImageProcessing:", File.join(@base, dst_dir, @name)

        return false if File.exist? dest_path and !modified?

        self.class.mtimes[path] = mtime

        FileUtils.mkdir_p(File.dirname(dest_path))
        image = ::ImageProcessing::Vips.source(path)
        commands.each_pair do |command, arg|
          image = image.send command, *arg
        end
        image.call(destination: dest_path)
        true
      end

    end

    class ImageGenerator < Generator
      safe true
      def generate(site)
        return unless site.config["image_processing"]

        site.config["image_processing"].each_pair do |name, preset|
          Dir.glob(File.join(site.source, preset["source"], "*.{png,jpg,jpeg,gif}")) do |source|
            options = preset.clone
            file = GeneratedImageFile.new(site, site.source, options["destination"], File.basename(source), nil)
            file.dst_dir = options.delete("destination")
            file.src_dir = options.delete("source")
            file.commands = options
            site.static_files << file
          end
        end
      end
    end
  end
end
