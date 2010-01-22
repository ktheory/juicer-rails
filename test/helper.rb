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

# Hack to stub out IO.foreach
class IO
  def self.foreach(path, seperator = $/, &block)
    File.read(path).split(seperator).each do |line|
      yield line
    end
    nil
  end
end

class Test::Unit::TestCase
end
