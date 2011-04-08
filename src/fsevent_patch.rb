class FSEvent
  def self.instances
    @instances ||=[ ]
  end
  def self.stop_all_instances
    instances.each do |x|
      x.stop
    end
  end
  def initialize
    self.class.instances << self
  end
end
