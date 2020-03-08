require "image_processing/vips"
require "zlib"

module Jekyll
  module JekyllImageProcessing
    class ProcessedImage < Jekyll::StaticFile
      attr_accessor :dst_dir, :src_dir, :commands

      def path
        File.join(@base, @dir.sub(dst_dir, src_dir), @name)
      end

      def write(dest)
        dest_path = destination(dest)

        return false if File.exist?(dest_path) && !modified?(dest_path)

        Jekyll.logger.debug "JekyllImageProcessing:", File.join(@base, dst_dir, @name)

        FileUtils.mkdir_p(File.dirname(dest_path))

        ::ImageProcessing::Vips.source(path).apply(commands).call(destination: dest_path)

        cache[cache_key(dest_path)] = cache_value

        true
      end

      def modified?(path)
        cache[cache_key(path)] != cache_value
      rescue
        true
      end

      def cache_key(path)
        @cache_key ||= Digest::MD5.hexdigest(File.read(path) + mtime.to_s)
      end

      def cache_value
        Digest::MD5.hexdigest(commands.to_s)
      end

      def cache
        @cache ||= Jekyll::Cache.new("Jekyll::JekyllImageProcessing")
      end

    end

    class ImageGenerator < Generator
      safe true
      def generate(site)
        return unless site.config["image_processing"]

        site.config["image_processing"].each_pair do |name, preset|
          Dir.glob(File.join(site.source, preset["source"], "*.{png,jpg,jpeg,gif}")) do |source|
            options = preset.clone
            file = ProcessedImage.new(site, site.source, options["destination"], File.basename(source), nil)
            file.dst_dir = options.delete("destination")
            file.src_dir = options.delete("source")
            file.commands = JSON.parse(JSON[options], symbolize_names: true)
            site.static_files << file
          end
        end
      end
    end
  end
end
