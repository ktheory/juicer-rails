require 'helper'

class TestJuicerActionViewHelper < Test::Unit::TestCase

  context "Juicer::ActionViewHelper" do

    should "not merge assets in development" do
      silence_warnings {::RAILS_ENV = "development"}
      assert !ActionView::Base.new.juice_assets?
    end

    should "merge assets in production" do
      silence_warnings {::RAILS_ENV = "production"}
      assert ActionView::Base.new.juice_assets?
    end

  end
end

