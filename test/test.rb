
require '../lib/custom_boolean'
require 'test/unit'

class CustomBooleanTest < Test::Unit::TestCase
  def test_if_true
    result = if?(5 == 5) { :is_equal }

    assert_equal(true, result.truth_value)
  end

  def test_if_false
    result = if?(5 == 6) { :is_equal }

    assert_equal(false, result.truth_value)
  end

  def test_else_if_true
    result = (if?(5 == 5) { :is_equal }.
      else_if?(6 == 6) { :is_equal })

    assert_equal(true, result.truth_value)
  end

  def test_else_if_false
    result = (if?(5 == 6) { :is_equal }.
      else_if?(6 == 7) { :is_equal })

    assert_equal(false, result.truth_value)
  end

  def test_else_true
    result = (if?(5 == 5) { :is_equal }.
      else? { :is_equal })

    assert_equal(:is_equal, result.value)
    assert_equal(:else_reached, result.truth_value)
  end

  def test_else_false
    result = (if?(5 == 6) { :is_equal }.
      else? { :is_equal })

    assert_equal(:is_equal, result.value)
  end

  def test_else_if_else_false
    result = if?(5 == 6) { :is_equal }.
      else_if?(5 == 7) { :is_equal }.
      else? { :is_equal }
  
    assert_equal(:is_equal, result.value)
    assert_equal(:else_reached, result.truth_value)
  end

  def test_else_if_true
    result = if?(5 == 5) { :is_equal_if }.
      else_if?(5 == 7) { :is_equal_else_if }.
      else? { :is_equal }
  
    assert_equal(:is_equal_if, result.value)
  end

  def test_else
    result = if?(5 == 0) { :is_equal }.
  else? { :in_else }

    assert_equal(:in_else, result.value)

    result = if?(5 == 5) { :is_equal }.
  else? { :in_else }

    assert_equal(:else_reached, result.truth_value)
  end

  def test_custom_truth
    CustomBoolean.truth_test = proc { |b| b && b != 0 }

    result = if?(0) { :is_equal }

    assert_equal(false, result.truth_value)

    # reset truth test
    CustomBoolean.truth_test = CustomBoolean::RUBY_TRUTH
  end

  def test_custom_truth_else
    CustomBoolean.truth_test = proc { |b| b && b != 0 }

    result = if?(0) { :is_equal }.
             else? { :in_else }

    assert_equal(:in_else, result.value)

    # reset truth test
    CustomBoolean.truth_test = CustomBoolean::RUBY_TRUTH
  end

  def test_nested_if
    CustomBoolean.truth_test = proc { |b| b && b != 0 }

    y = :blah
    result = if?(1) {
      if?(0) { }.
      else_if?(1) {
        y = :nested
      }
      
    }.
    else_if?(1) {
      y = :else_if
    }

    assert_equal(:nested, y)

    CustomBoolean.truth_test = CustomBoolean::RUBY_TRUTH
  end

  def test_values
    val = :outside_if
    val = if?(true) {
        :in_if
      }
    assert_equal(:in_if, val.value)

    val = if?(true) {
      :in_if
    }.
    else_if?(true) {
      :in_
    }

    assert_equal(:in_if, val.value)
  end

  def test_values_else_if_chain
    val = if?(true) {
      :hello
    }.
    elsif?(true) {
    }.
    else_if?(true) {
    }

    assert_equal(:hello, val.value)

    val = if?(false) {
    }.
    elsif?(true) {
      :goodbye
    }.
    else_if?(true) {
    }

    assert_equal(:goodbye, val.value)

    val = if?(false) {
    }.
    elsif?(false) {
    }.
    else_if?(true) {
      :tiger
    }

    assert_equal(:tiger, val.value)    
  end

  def test_conditional_after_else_exception

    assert_raises(CustomBoolean::InvalidConditional) do
      if?(true) {}.
      else? {}.
      else? {}
    end

    assert_raises(CustomBoolean::InvalidConditional) do
      if?(false) {}.
      else_if?(true) {}.
    else? {}.
      else_if?(false) {}
    end
  end

  def test_else_if_aliases
    assert_nothing_thrown do
      if?(false) {}.
      else_if(false) {}.
      else_if!(false) {}.
      else_if?(false) {}.
      elsif?(true) {}.
      elsif!(true) {}.
      elsif(true) {}.
      else {}
    end
  end

  def test_perl_truth
    CustomBoolean.truth_test = CustomBoolean::PERL_TRUTH

    ["0", "", 0].each do |v|
      val = if?(v) {
        true
      }.
      else? {
        false
      }
      assert_equal(false, val.value)
    end

    val = if?("hello") {
      true
    }.
    else? {
      false
    }
    assert_equal(true, val.value)

    CustomBoolean.truth_test = CustomBoolean::RUBY_TRUTH
  end

  def test_python_truth
    CustomBoolean.truth_test = CustomBoolean::PYTHON_TRUTH

    [{}, [], "", 0].each do |v|
      val = if?(v) {
        true
      }.
      else? {
        false
      }
      assert_equal(false, val.value)
    end

    val = if?("hello") {
      true
    }.
    else? {
      false
    }
    assert_equal(true, val.value)

    CustomBoolean.truth_test = CustomBoolean::RUBY_TRUTH
  end

  def test_strict_truth
    CustomBoolean.truth_test = CustomBoolean::STRICT_TRUTH

    assert_nothing_thrown do
      val = if?(true) {
        true
      }.
      else? {
        false
      }

      assert_equal(true, val.value)

      val = if?(false) {
        true
      }.
      else? {
        false
      }

      assert_equal(false, val.value)
    end

    [nil, 0, "", "hello", [], {}].each do |v|
      assert_raises(RuntimeError) do
        if?(v) {}
      end
    end
    CustomBoolean.truth_test = CustomBoolean::RUBY_TRUTH
  end

  def test_c_truth
    CustomBoolean.truth_test = CustomBoolean::C_TRUTH
    
    [nil, false, 0].each do |v|
      val = if?(v) {
        true
      }.
      else? {
        false
      }
      assert_equal(false, val.value)
    end

   [true, "hello", []].each do |v|
    val = if?(v) {
        true
      }.
      else? {
        false
      }
      assert_equal(true, val.value)
    end
  end

  def test_ruby_truth
    CustomBoolean.truth_test = CustomBoolean::RUBY_TRUTH

    [nil, false].each do |v|
      val = if?(v) {
        true
      }.
      else? {
        false
      }
      assert_equal(false, val.value)
    end

   [true, "hello", []].each do |v|
    val = if?(v) {
        true
      }.
      else? {
        false
      }
      assert_equal(true, val.value)
    end
    CustomBoolean.truth_test = CustomBoolean::RUBY_TRUTH
  end

  def test_perl_truth_operators
    CustomBoolean.truth_test = CustomBoolean::PERL_TRUTH

    truthy_value = "0"
    
    [:and, :or].each do |o|
      v = +if?(truthy_value.send(o, true)) {
        true
      }.
      else! {
        false
      }

      assert_equal(true, v) if o == :or
        assert_equal(false, v) if o == :and
    end

    v = +if?(negate(truthy_value)) {
            true
              }.
            else! {
                false
              }

    assert_equal(true, v)
    
    CustomBoolean.truth_test = CustomBoolean::RUBY_TRUTH
  end
             
  def test_python_truth_operators
    CustomBoolean.truth_test = CustomBoolean::PYTHON_TRUTH

    truthy_value = []
    [:and, :or].each do |o|
      v = +if?(truthy_value.send(o, true)) {
        true
      }.
      else! {
        false
      }

      assert_equal(true, v) if o == :or
        assert_equal(false, v) if o == :and
    end

    v = +if?(negate(truthy_value)) {
            true
              }.
            else! {
                false
              }

    assert_equal(true, v)
    
    CustomBoolean.truth_test = CustomBoolean::RUBY_TRUTH
  end

  def test_c_truth_operators
    CustomBoolean.truth_test = CustomBoolean::C_TRUTH

    truthy_value = 0
    [:and, :or].each do |o|
      v = +if?(truthy_value.send(o, true)) {
        true
      }.
      else! {
        false
      }

      assert_equal(true, v) if o == :or
        assert_equal(false, v) if o == :and
    end

    v = +if?(negate(truthy_value)) {
            true
              }.
            else! {
                false
              }

    assert_equal(true, v)
    
    CustomBoolean.truth_test = CustomBoolean::RUBY_TRUTH
  end

  def test_if_expression
    CustomBoolean.truth_test = CustomBoolean::RUBY_TRUTH

    v = +if?(true) {
      :hero
    }.
    else {
      :ostrich
    }

    assert_equal(:hero, v)
  end
end

 
