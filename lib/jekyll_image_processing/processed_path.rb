module Jekyll
  module JekyllImageProcessing
    module ProcessedPath
      include Jekyll::Filters::URLFilters

      def processed_path(name, variant = "")
        config = @context.registers[:site].config
        options = config.dig("image_processing", variant)
        if name && options
          path = options.dig("destination")
          fingerprint_name = Fingerprint.new(name, options)
          relative_url("#{path}/#{fingerprint_name}")
        end
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::JekyllImageProcessing::ProcessedPath)