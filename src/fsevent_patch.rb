class FSEvent
  def self.instances
    @instances ||=[ ]
  end
  def self.stop_all_instances
    sleep 0.1
    instances.each do |x|
      x.stop if x.pipe
    end
  end
  def initialize
    self.class.instances << self
  end
  def stop
    if pipe
      Process.kill("KILL", pipe.pid)
      pipe.close
    end 
  rescue 
  ensure
    @pipe = false
  end

end
