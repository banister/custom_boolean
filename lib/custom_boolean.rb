# CustomBoolean by John Mair (banisterfiend)
# MIT license

direc = File.dirname(__FILE__)
require "#{direc}/custom_boolean/version"

# @author John Mair (banisterfiend)
class CustomBoolean
  module Operators

    # Equivalent of *&&* for CustomBoolean truthiness.
    # Differs from regular *&&* as it uses CustomBoolean truthiness
    # 
    # *NOTE:* It is usually better to use the {#and} alias, as fewer objects override this
    # method)
    #
    # @param other The rhs of the boolean *and* operator
    # @return [Boolean]
    # @example 
    #   obj1 & obj2
    #   obj1.and obj2
    def &(other)
      CustomBoolean.truthy?(self) && CustomBoolean.truthy?(other)
    end
    alias_method :and, :"&"
    
    # Equivalent of *||* for CustomBoolean truthiness.
    # Differs from regular *||* as it uses CustomBoolean truthiness
    # 
    # *NOTE:* It is usually better to use the {#or} alias, as fewer objects override this
    # method)
    #
    # @param other The rhs of the boolean *or* operator
    # @return [Boolean]
    # @example 
    #   obj1 | obj2
    #   obj1.or obj2
    def |(other)
      CustomBoolean.truthy?(self) || CustomBoolean.truthy?(other)
    end
    alias_method :or, :"|"
  end
end

# Unfortunately patching these objects is necessary :(
true.extend(CustomBoolean::Operators)
false.extend(CustomBoolean::Operators)
Object.send(:include, CustomBoolean::Operators)

# Equivalent of *!* for CustomBoolean truthiness.
# Differs from regular *!* as it uses CustomBoolean truthiness
# 
# @param expr The expression to be negated
# @return [Boolean]
# @example 
#   negate(obj)
def negate(expr)
  !CustomBoolean.truthy?(expr)
end

# Equivalent of *if* for CustomBoolean truthiness.
# Differs from regular *if* as it uses CustomBoolean truthiness
#
# @example basic usage
#   # Use as follows:
#   if_(condition) { ... }
#   
#   # Other conditionals chain on to the end of if_() as follows:
#   if_(condition) { ... }
#   .else { ... }
# @example if-expression form
#   # Can turn if_() statement into if-expression by prefixing with a `+`
#   value = +if_(true) { :hello }
#   value #=> :hello
# @param condition an expression to evaluate
# @return [CustomBoolean]
# @yield the block will be executed if the condition evalues to true
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

  # @return [Boolean] 
  attr_accessor :truth_value

  # @return [Object] The value of the block that was executed in the
  #   if/else_if/else 
  attr_accessor :value

  class << self

    # Determines the truth test to apply (for CustomBoolean truthiness)
    # 
    # Built in Truth tests include:
    # 
    # *CustomBoolean::RUBY_TRUTH*
    # 
    # *CustomBoolean::PYTHON_TRUTH*
    # 
    # *CustomBoolean::PERL_TRUTH*
    # 
    # *CustomBoolean::C_TRUTH*
    # 
    # *CustomBoolean::STRICT_TRUTH*
    # 
    # @example changing truthiness to a preset 
    #   CustomBoolean.truth_test = CustomBoolean::PYTHON_TRUTH
    # @example user-defined truthiness 
    #   # only :horse is true:
    #   CustomBoolean.truth_test = proc { |expr| expr == :horse }
    # @param [Proc] truth_test_proc The Proc that defines the truth test
    # @return [Proc] The proc that defines the truth test
    attr_accessor :truth_test

    # Tests whether *expression* is truthy according to
    # CustomBoolean truthiness.
    # CustomBoolean truthiness is determined by the proc referenced
    # by CustomBoolean.truth_test.
    # @param expr an expression to evaluate
    # @return [Boolean]
    # @example using C truthiness
    #   CustomBoolean.truth_test = CustomBoolean::C_TRUTH
    #   CustomBoolean.truthy?(0) #=> false
    # @example defining and using *horse* truthiness :)
    #   # only :horse is *true*
    #   CustomBoolean.truth_test = proc { |expr| expr == :horse }
    #   CustomBoolean.truthy?(:horse) #=> true
    #   CustomBoolean.truthy?(true) #=> false
    def truthy?(expr)
      self.truth_test.call(expr)
    end
  end

  InvalidConditional = Class.new(StandardError)
  
  RUBY_TRUTH = proc { |expr| expr }
  PYTHON_TRUTH = proc { |expr| expr && !(expr.respond_to?(:empty?) && expr.empty?) && expr != 0 }
  STRICT_TRUTH = proc { |expr| raise "Expression must be strictly true or false." if expr != true && expr != false; expr }
  PERL_TRUTH = proc { |expr| expr && expr != 0 && expr != "" && expr != "0" }
  C_TRUTH = proc { |expr| expr && expr != 0 }
  
  # default truth test is Ruby's
  self.truth_test = RUBY_TRUTH
  
  # @param [Boolean, Symbol] truth_value
  # @param block_value 
  def initialize(truth_value, block_value)
    self.truth_value = truth_value
    self.value = block_value
  end

  # Prefixing +if_+ with *+* turns if-statement into if-expression
  # by invoking #value on CustomBoolean object.
  # @return [Object] extracts the value of the if, transforming it
  #   into an if-expression
  # @example single if-expression example
  #   +if_(true) { :hello } #=> :hello
  #   +if_(false) { :hello } #=> nil
  # @example if-else-expression example
  #   +if_(false) {
  #     :hello
  #   }.
  #   else {
  #     :goodbye
  #   }
  #   #=> :goodbye
  def +@
    self.value
  end
  
  # Equivalent of **elsif** for CustomBoolean truthiness.
  # Must be chained after an if_() or another else_if()
  # 
  # Differs from regular **elsif** as it uses CustomBoolean truthiness
  #
  # @example else_if example
  #   if_(cond) {
  #     :hello
  #   }.
  #   else_if(cond2) {
  #     :goodbye
  #   }
  # @param condition an expression to evaluate
  # @return [CustomBoolean]
  # @yield the block will be executed if the condition evalues to true
  #   (so long as no prior *else_if* or *if* has evaluated to true further up the chain)
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
  
  # Equivalent of **else** for CustomBoolean truthiness.
  # Must be chained after an if_() or an else_if()
  # 
  # Differs from regular **else** as it uses CustomBoolean truthiness
  # 
  # No other conditionals may be chained after an +else+.
  # In event a conditional is chained after an +else+ an
  # **InvalidConditional** exception will be raised.
  #
  # @example else example
  #   if_(cond) {
  #     :hello
  #   }.
  #   else {
  #     :goodbye
  #   }
  # @return [CustomBoolean]
  # @yield the block will be executed if the condition evalues to true
  #   (so long as no prior *else_if* or *if* has evaluated to true further up the chain)
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

