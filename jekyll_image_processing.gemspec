require_relative 'lib/jekyll_image_processing/version'

Gem::Specification.new do |spec|
  spec.name          = "jekyll_image_processing"
  spec.version       = JekyllImageProcessing::VERSION
  spec.authors       = ["Ben Ubois"]
  spec.email         = ["ben@benubois.com"]

  spec.summary       = %q{Process images with image_processing.}
  spec.homepage      = "https://github.com/benubois/jekyll_image_processing"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/benubois/jekyll_image_processing"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency("jekyll", [">= 0.10.0"])
  spec.add_runtime_dependency("image_processing", [">= 1.10.3"])
end
