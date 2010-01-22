# Require a bleeding edge version of juicer
gem "juicer", "> 0.9"
require 'juicer'
require 'juicer/package'
require 'action_view'

module Juicer::ActionViewHelper

  mattr_accessor :unminified_environments, :use_embedded_images
  @@unminified_environments = ["development"]
  @@use_embedded_images = false

  def juiced_tag(asset_path)
    package = Juicer::Package.new(asset_path)
    case package.extension
    when ".css"
      if should_merge_assets?
        if should_use_embedded_images?
          conditional_css_tag(package.embedded_path, package.minified_path)
        else
          stylesheet_link_tag(package.minified_path)
        end
      else
        stylesheet_link_tag(package.dependencies)
      end
    when ".js"
      if should_merge_assets?
        javascript_include_tag(package.minified_path)
      else
        javascript_include_tag(package.dependencies)
      end
    end
  end

  def should_merge_assets?
    ! @@unminified_environments.include?(RAILS_ENV)
  end

  def should_use_embedded_images?
    @@use_embedded_images
  end

  protected
  def conditional_css_tag(embedded_path, normal_path)
    embedded_tag = stylesheet_link_tag(embedded_path)
    normal_tag = stylesheet_link_tag(normal_path)

    %{
      <!--[if !IE]>-->
      #{embedded_tag}
      <!--<![endif]-->
      <!--[if gte IE 8]>
      #{embedded_tag}
      <![endif]-->
      <!--[if lte IE 7]>
      #{normal_tag}
      <![endif]-->
    }.rstrip
  end
end

ActionView::Base.send(:include, Juicer::ActionViewHelper)
