require 'test_helper'

class RubyClickyTest < Test::Unit::TestCase
  should "return true for a valid Clicky log invocation" do
    assert GetClicky.log(:href => "http://www.google.com", :ip_address => "127.0.0.1")
  end
  
  should "raise ArgumentError if passing invalid parameters to method" do
    assert_raises ArgumentError do
      assert GetClicky.log
    end
  end
end
