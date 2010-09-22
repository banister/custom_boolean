
require '../lib/custom_boolean'
require 'test/unit'


class CustomBooleanTest < Test::Unit::TestCase
  def test_if_true
    result = if! (5 == 5) { :is_equal }

    assert_equal(true, result.truth_value)
  end

  def test_if_false
    result = if! (5 == 6) { :is_equal }

    assert_equal(false, result.truth_value)
  end

  def test_else_if_true
    result = (if!(5 == 5) { :is_equal }.
      else_if!(6 == 6) { :is_equal })

    assert_equal(true, result.truth_value)
  end

  def test_else_if_false
    result = (if!(5 == 6) { :is_equal }.
      else_if!(6 == 7) { :is_equal })

    assert_equal(false, result.truth_value)
  end

  def test_else_true
    result = (if!(5 == 5) { :is_equal }.
      else! { :is_equal })

    assert_equal(nil, result)
  end

  def test_else_false
    result = (if!(5 == 6) { :is_equal }.
      else! { :is_equal })

    assert_equal(:is_equal, result)
  end

  def test_else_if_else_false
    result = if!(5 == 6) { :is_equal }
      .else_if!(5 == 7) { :is_equal }
      .else! { :is_equal }
  
    assert_equal(:is_equal, result)
  end

  def test_else_if_true
    result = if!(5 == 5) { :is_equal }
      .else_if!(5 == 7) { :is_equal }
      .else! { :is_equal }
  
    assert_equal(nil, result)
  end

  def test_else
    result = if!(5 == 0) { :is_equal }.
  else! { :in_else }

    assert_equal(:in_else, result)

    result = if!(5 == 5) { :is_equal }.
  else! { :in_else }

    assert_equal(nil, result)
  end

  def test_custom_truth
    CustomBoolean.truth_test = proc { |b| b && b != 0 }

    result = if!(0) { :is_equal }

    assert_equal(false, result.truth_value)

    # reset truth test
    CustomBoolean.truth_test = proc { |b| !!b }
  end

  def test_custom_truth_else
    CustomBoolean.truth_test = proc { |b| b && b != 0 }

    result = if!(0) { :is_equal }.
  else! { :in_else }

    assert_equal(:in_else, result)

    # reset truth test
    CustomBoolean.truth_test = proc { |b| !!b }
  end  
end

