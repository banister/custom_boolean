# CustomBoolean by John Mair (banisterfiend)
# MIT license

def if!(condition, &block)
  truth = CustomBoolean.truthy?(condition)
  block.call if truth
  CustomBoolean.new(truth)
end

class CustomBoolean
  attr_accessor :truth_value

  class << self
    attr_accessor :truth_test

    def truthy?(condition)
      self.truth_test.call(condition)
    end
  end

  # default truth test (same as Ruby's)
  self.truth_test = proc { |expr| !!expr }
  
  def initialize(truth_value)
    self.truth_value = !!truth_value
  end
  
  def else_if!(condition, &block)
    if self.truth_value
      CustomBoolean.new(true)
    else
      truth = CustomBoolean.truthy?(condition)
      block.call if truth
      CustomBoolean.new(truth)
    end
  end

  alias_method :elsif!, :else_if!
  alias_method :elif!, :else_if!
  alias_method :elseif!, :else_if!
  
  def else!(&block)
    block.call unless self.truth_value
  end
end

