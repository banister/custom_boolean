# CustomBoolean by John Mair (banisterfiend)
# MIT license


direc = File.dirname(__FILE__)
require "#{direc}/custom_boolean/version"

class CustomBoolean
  module Operators

    # Equivalent of && for CustomBoolean truthiness
    # (Better to use #and() alias, as fewer objects override this method)
    def &(other)
      CustomBoolean.truthy?(self) && CustomBoolean.truthy?(other)
    end
    alias_method :and, :"&"
    
    # Equivalent of || for CustomBoolean truthiness
    # (Better to use #or() alias, as fewer objects override this method)
    def |(other)
      CustomBoolean.truthy?(self) || CustomBoolean.truthy?(other)
    end
    alias_method :or, :"|"
  end
end

true.extend(CustomBoolean::Operators)
false.extend(CustomBoolean::Operators)
Object.send(:include, CustomBoolean::Operators)

# Equivalent to ! for CustomBoolean truthiness
def negate(expr)
  !CustomBoolean.truthy?(expr)
end

# CustomBoolean version of +if+ keyword.
# Use as follows: if_(condition) { ... }
# Other conditionals chain on to the end of if_() as follows:
# if_(condition) { ... }.else { ... }
# Can turn if_() statement into if-expression by prefixing with a `+`
# e.g value = +if_(true) { :hello }
# value #=> :hello
def if_(condition, &block)
  truth = !!CustomBoolean.truthy?(condition)
  bvalue = block.call if truth
  CustomBoolean.new(truth, bvalue)
end

# bunch of aliases for if_
alias if! if_
alias _if if_
alias if? if_

class CustomBoolean
  attr_accessor :truth_value, :value

  class << self
    attr_accessor :truth_test

    # Indicates whether +condition+ is truthy according to
    # CustomBoolean truthiness.
    # CustomBoolean truthiness is determined by the proc referenced
    # by CustomBoolean.truth_test.
    # Built in Truth tests include:
    # CustomBoolean::RUBY_TRUTH
    # CustomBoolean::PYTHON_TRUTH
    # CustomBoolean::PERL_TRUTH
    # CustomBoolean::C_TRUTH
    # CustomBoolean::STRICT_TRUTH
    # Change truthiness by going, e.g:
    # CustomBoolean.truth_test = CustomBoolean::PYTHON_TRUTH
    # Can also use customized concept of truth, e.g horse truthiness -
    # only :horse is true:
    # CustomBoolean.truth_test = proc { |expr| expr == :horse }
    def truthy?(condition)
      self.truth_test.call(condition)
    end
  end

  # exception raised when conditionals invoked after an else
  InvalidConditional = Class.new(StandardError)
  
  # various ideas of truth
  RUBY_TRUTH = proc { |expr| expr }
  PYTHON_TRUTH = proc { |expr| expr && !(expr.respond_to?(:empty?) && expr.empty?) && expr != 0 }
  STRICT_TRUTH = proc { |expr| raise "Expression must be strictly true or false." if expr != true && expr != false; expr }
  PERL_TRUTH = proc { |expr| expr && expr != 0 && expr != "" && expr != "0" }
  C_TRUTH = proc { |expr| expr && expr != 0 }
  
  # default truth test is Ruby's
  self.truth_test = RUBY_TRUTH
  
  def initialize(truth_value, block_value)
    self.truth_value = truth_value
    self.value = block_value
  end

  # Prefixing +if_+ with `+` turns if-statement into if-expression
  # by invoking #value on CustomBoolean object.
  def +@
    self.value
  end
  
  # CustomBoolean equivalent to Ruby's +elsif+ keyword.
  # Must be chained after an if_() or another else_if()
  def else_if(condition, &block)
    raise InvalidConditional, "No further conditionals allowed after an else." if self.truth_value == :else_reached

    if self.truth_value
      CustomBoolean.new(true, self.value)
    else
      truth = !!CustomBoolean.truthy?(condition)
      bvalue = block.call if truth
      CustomBoolean.new(truth, bvalue)
    end
  end

  # a bunch of aliases for else_if
  alias else_if? else_if
  alias else_if! else_if
  alias elsif else_if
  alias elsif? else_if
  alias elsif! else_if
  
  # CustomBoolean equivalent to Ruby's +else+ keyword.
  # Must be chained after an if_() or else_if() keyword.
  # No other conditionals may be chained after an +else+
  # In event a conditional is chained after an +else+ an
  # InvalidConditional exception will be raised.
  def else(&block)
    raise InvalidConditional, "No further conditionals allowed after an else." if self.truth_value == :else_reached

    if self.truth_value
      CustomBoolean.new(:else_reached, self.value)
    else
      bvalue = block.call 
      CustomBoolean.new(:else_reached, bvalue)
    end
  end

  # a bunch of aliases for else 
  alias else? else
  alias else! else
end

