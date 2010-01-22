require 'juicer_rails'

def javascript_manifests
  manifests(".js")
end

def stylesheet_manifests
  manifest(".css")

def manifests(ext)
  Dir.glob("**/*#{ext}")
  
end

namespace :juicer do
  task :build_manifests do
    Dir
  end
end