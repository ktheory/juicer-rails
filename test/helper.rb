require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'juicer/action_view_helper'

gem "ktheory-fakefs"
require "fakefs/safe"

def fake_write(path, data)
  FileUtils.mkdir_p(File.dirname(path))
  File.open(path, 'w'){|f| f.write(data)}
end

class Test::Unit::TestCase
end
