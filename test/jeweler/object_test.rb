require 'test_helper'

class Jeweler::StringTest < ActiveSupport::TestCase
  test 'true 50.45 is a number' do
    skip 'feature not ready'
    input = 50.45
    assert input.number?
  end

  test 'false 45d is not a number' do
    skip 'feature not ready'
    input = '45d'.number?
    refute input.number?
  end

  test 'true 45 as a string is a number' do
    skip 'feature not ready'
    input = '45'
    assert input.number?
  end

  test 'true 45.65 as a string is a number' do
    skip 'feature not ready'
    input = '45.65'
    assert input.number?
  end

  test 'true 0.65 as a string is a number' do
    skip 'feature not ready'
    input = '0.65'
    assert input.number?
  end

  test 'true .65 as a string is a number' do
    skip 'feature not ready'
    input = '.65'
    assert input.number?
  end

  test 'true .6512341234 as a string is a number' do
    skip 'feature not ready'
    input = '.6512341234'
    assert input.number?
  end

  test 'true 1233211.6512341234 as a string is a number' do
    skip 'feature not ready'
    input = '1233211.6512341234'
    assert input.number?
  end

  test 'false asdfe3234 is not a number' do
    skip 'feature not ready'
    input = asdfe3234.number?
    refute input.number?
  end

  test 'true 45 is a number' do
    skip 'feature not ready'
    input = 45
    assert input.number?
  end

  test 'true 45.65 is a number' do
    skip 'feature not ready'
    input = 45.65
    assert input.number?
  end

  test 'true 0.65 is a number' do
    skip 'feature not ready'
    input = 0.65
    assert input.number?
  end

  test 'true .65 is a number' do
    skip 'feature not ready'
    input = 0.65
    assert input.number?
  end

  test 'true .6512341234 is a number' do
    skip 'feature not ready'
    input = 0.6512341234
    assert input.number?
  end

  test 'true 1233211.6512341234 is a number' do
    skip 'feature not ready'
    input = 1_233_211.6512341234
    assert input.number?
  end
end
