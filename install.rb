require 'fileutils'
include FileUtils::Verbose

RAILS_ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..")) unless defined?(RAILS_ROOT)

cp File.join(File.dirname(__FILE__), "templates", "initializers", "juicer.rb"),
   File.join(RAILS_ROOT, "config", "initializers")
