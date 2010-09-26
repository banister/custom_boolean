# CustomBoolean by John Mair (banisterfiend)
# MIT license

def if!(condition, &block)
  truth = !!CustomBoolean.truthy?(condition)
  bvalue = block.call if truth
  CustomBoolean.new(truth, bvalue)
end

class CustomBoolean
  attr_accessor :truth_value, :block_value

  class << self
    attr_accessor :truth_test

    def truthy?(condition)
      self.truth_test.call(condition)
    end
  end

  # exception raised when conditionals invoked after an else
  InvalidConditional = Class.new(StandardError)
  
  # default truth test (same as Ruby's)
  RUBY_TRUTH = proc { |expr| expr }
  PYTHON_TRUTH = proc { |expr| expr && !(expr.respond_to?(:empty?) && expr.empty?) && expr != 0 }
  STRICT_TRUTH = proc { |expr| raise "Expression must be strictly true or false." if expr != true && expr != false; expr }
  PERL_TRUTH = proc { |expr| expr && expr != 0 && expr != "" && expr != "0" }
  C_TRUTH = proc { |expr| expr && expr != 0 }
    
  self.truth_test = RUBY_TRUTH
  
  def initialize(truth_value, block_value)
    self.truth_value = truth_value
    self.block_value = block_value
  end
  
  def else_if!(condition, &block)
    raise InvalidConditional, "No further conditionals allowed after an else." if self.truth_value == :else_reached

    if self.truth_value

      # current conditional is true so just pass on truth and do not
      # run block.
      CustomBoolean.new(true, self.block_value)
    else

      # current conditional is false so check next conditional for truth
      truth = !!CustomBoolean.truthy?(condition)

      # run block if next conditional is true
      bvalue = block.call if truth

      # pass on new truth value
      CustomBoolean.new(truth, bvalue)
    end
  end

  alias_method :elsif!, :else_if!
  alias_method :elif!, :else_if!
  alias_method :elseif!, :else_if!
  
  def else!(&block)
    raise InvalidConditional, "No further conditionals allowed after an else." if self.truth_value == :else_reached

    if self.truth_value
      CustomBoolean.new(:else_reached, self.block_value)
    else
      bvalue = block.call 
      CustomBoolean.new(:else_reached, bvalue)
    end
  end
end

