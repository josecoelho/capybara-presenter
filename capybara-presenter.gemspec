# frozen_string_literal: true

require_relative "lib/capybara/presenter/version"

Gem::Specification.new do |spec|
  spec.name = "capybara-presenter"
  spec.version = Capybara::Presenter::VERSION
  spec.authors = ["José Coelho"]
  spec.email = ["jose.coelho@palomagroup.com"]

  spec.summary = "Make Capybara tests presentation-ready with visual notifications and recording-friendly delays"
  spec.description = "Transform Capybara system tests into polished presentations with automatic delays, browser notifications, and visual cues perfect for creating professional test recordings and demonstrations."
  spec.homepage = "https://github.com/josecoelho/capybara-presenter"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/josecoelho/capybara-presenter"
  spec.metadata["changelog_uri"] = "https://github.com/josecoelho/capybara-presenter/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ examples/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "capybara", ">= 3.0"
  spec.add_dependency "selenium-webdriver", ">= 4.0"

  # Development dependencies
  spec.add_development_dependency "lefthook", "~> 1.11"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "~> 1.75"
  spec.add_development_dependency "rubocop-minitest", "~> 0.38"
end
