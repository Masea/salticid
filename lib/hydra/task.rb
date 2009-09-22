class Hydra::Task
  # A named block, runnable in some context
  attr_accessor :name, :block

  def initialize(name, opts = {})
    @name = name.to_s
  end

  def ==(other)
    self.name == other.name and
    self.block == other.block
  end

  def dup
    dup = Hydra::Task.new(@name)
    dup.block = @block 
    dup
  end

  def inspect
    "#<Task #{@name}>"
  end

  # Sets or gets the name of this task.
  def name(name = nil)
    if name
      @name = name.to_s
    else
      @name
    end
  end

  # Runs the task in a given context
  def run(context = nil, *args)
    if context
      context.instance_exec(*args, &@block)
    else
      @block.call(*args)
    end
  end

  def to_s
  end
end
