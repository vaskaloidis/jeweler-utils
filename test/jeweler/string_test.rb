require 'test_helper'

class Jeweler::StringTest < ActiveSupport::TestCase
  test 'string money method formats money' do
    input = 50.45
    assert_equal input.money, '$50.45'
  end

  test 'string to_b converts explicit boolean strings correctly' do
    assert 'true'.to_b
    refute 'false'.to_b
    #   TODO: Check it raises an exception for anything else
  end

  test 'true? method returns true for explicit strings' do
    assert 'true'.true?
    refute 'truue'.true?
  end
end
