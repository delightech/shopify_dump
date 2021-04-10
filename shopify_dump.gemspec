# frozen_string_literal: true

require_relative "lib/shopify_dump/version"

Gem::Specification.new do |spec|
  spec.name          = "shopify_dump"
  spec.version       = ShopifyDump::VERSION
  spec.authors       = ["delightech"]
  spec.email         = ["hisafumi.kikkawa@gmail.com"]

  spec.summary       = "Module for Shopify data dump"
  spec.description   = "Module for Shopify data dump"
  spec.homepage      = "https://github.com/delightech/shopify_dump"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "rake", "~> 13.0.3"
  spec.add_dependency "shopify_api", "~> 9.4.1"
end
