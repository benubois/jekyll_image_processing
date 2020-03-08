module Jekyll
  module JekyllImageProcessing
    module ProcessedPath
      def processed_path(name, variant = "")
        config = @context.registers[:site].config
        path = config.dig("image_processing", variant, "destination")
        [
          config["baseurl"],
          path,
          name
        ].compact.join("/")
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::JekyllImageProcessing::ProcessedPath)