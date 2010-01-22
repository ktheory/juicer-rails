require 'juicer'
require 'pathname'
require 'action_view'

class Juicer::Package

  cattr_accessor :default_options
  @@default_options = {:document_root => "public"}

  attr_accessor :path, :extension

  def initialize(path, options = {})
    @path = path
    @extension = "." + path.split(".").last # .css or .js
    @options = default_options.merge(options)
  end

  # Returns the conventional minified path. E.g., if @path = /js/app.js, 
  # the minified path is /js/app.min.js
  def minified_path
    dirname = File.dirname(path)
    basename = File.basename(path, extension)
    File.join(dirname, basename + ".min" + extension)
  end

  # Returns the conventional embedded path. E.g., if @path = /css/app.css,
  # the minified path is /css/app.embedded.js
  def embedded_path
    dirname = File.dirname(path)
    basename = File.basename(path, extension)
    File.join(dirname, basename + ".embedded" + extension)
  end

  def default_options
    self.class.default_options
  end

  def path_with_document_root
    File.join(@options[:document_root], path)
  end

  def resolver
    case extension
    when ".js"
      Juicer::JavaScriptDependencyResolver.new(@options)
    when ".css"
      Juicer::CssDependencyResolver.new(@options)
    end
  end

  #  Returns an array of absolute paths upon which @path depends
  def absolute_dependencies
    resolver.resolve(path_with_document_root)
  end

  # Returns an array of paths relative to web root
  def dependencies
    document_root = Pathname.new(File.join(Dir.pwd, @options[:document_root]))
    absolute_dependencies.map do |full_path|
      relative_path = Pathname.new(full_path).relative_path_from(document_root).to_s
      File.join("/", relative_path)
    end
  end
end