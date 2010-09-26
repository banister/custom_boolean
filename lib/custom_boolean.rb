# CustomBoolean by John Mair (banisterfiend)
# MIT license

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

