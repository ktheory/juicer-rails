require 'helper'

class TestJuicerPackage < Test::Unit::TestCase
  context "A Juicer Package" do
    setup do

      FakeFS.activate!
      FakeFS::FileSystem.clear

      @web_root = "public"
      Juicer::Package.default_options = {:web_root => @web_root}

      @public_path = File.join(RealDir.pwd, @web_root)
      FileUtils.mkdir_p(@public_path)

      # js/app.js depends on pkg
      fake_write("#{@web_root}/js/app.js", "// @depend pkg\nvar myApp = "";")
      # js/pkg/a.js
      fake_write("#{@web_root}/js/pkg/a.js", "var a = "";")
      # js/pkg/pkg.js depends on a.js
      fake_write("#{@web_root}/js/pkg/pkg.js", "// @depend a.js\nvar pkg = "";")
      @expected_dependencies = %w(/js/pkg/a.js /js/pkg/pkg.js /js/app.js)

      @path = "/js/app.js"
      @package = Juicer::Package.new(@path)
    end

    teardown do
      FakeFS.deactivate!
    end

    should "have paths relative to web root" do
      path_with_web_root = File.join(@web_root, @path)
      assert_equal path_with_web_root, @package.path_with_web_root
    end

    should "have absolute dependencies" do
      absolute_paths = @expected_dependencies.map do |path|
        File.join(@public_path, path)
      end
      assert_equal absolute_paths, @package.absolute_dependencies
    end

    should "return dependencies relative to web root" do
      assert_equal @expected_dependencies, @package.dependencies
    end

    should "calculate minified paths" do
      path = Juicer::Package.new("/css/app.css").minified_path
      assert_equal "/css/app.min.css", path
    end

    should "calculate embedded paths" do
      path = Juicer::Package.new("/css/app.css").embedded_path
      assert_equal "/css/app.embedded.css", path
    end

  end
end
