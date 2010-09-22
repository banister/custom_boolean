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

  def else!(&block)
    block.call unless self.truth_value
  end
end

