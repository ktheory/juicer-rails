# Require a bleeding edge version of juicer
gem "juicer", "> 0.9"
require 'juicer'
require 'juicer/package'
require 'action_view'

module Juicer::ActionViewHelper

  mattr_accessor :unjuiced_environments, :embed_images
  @@unjuiced_environments = ["development"]
  @@embed_images = false

  def juiced_tag(asset_path)
    package = Juicer::Package.new(asset_path)
    case package.extension
    when ".css"
      if juice_assets? and embed_images?
        conditional_css_tag(package.embedded_path, package.minified_path)
      elsif juice_assets?
        stylesheet_link_tag(package.minified_path)
      else
        stylesheet_link_tag(package.dependencies)
      end
    when ".js"
      if juice_assets?
        javascript_include_tag(package.minified_path)
      else
        javascript_include_tag(package.dependencies)
      end
    end
  end

  # Write one tag for the minified path, or write tags for each dependency
  def juice_assets?
    ! @@unjuiced_environments.include?(RAILS_ENV)
  end

  def embed_images?
    @@embed_images
  end

  protected
  def conditional_css_tag(embedded_path, normal_path)
    embedded_tag = stylesheet_link_tag(embedded_path)
    normal_tag = stylesheet_link_tag(normal_path)

    %{
      <!--[if (!IE)|(gte IE 8)]>
      #{embedded_tag}
      <![endif]-->
      <!--[if lte IE 7]>
      #{normal_tag}
      <![endif]-->
    }.rstrip
  end
end

ActionView::Base.send(:include, Juicer::ActionViewHelper)
