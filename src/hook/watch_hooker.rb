
module CompassHooker

  module WatchHooker 
    extend self

    def watch(glob, &block)
      Compass.configuration.watch(glob, &block)
    end

    def watches
      Compass.configuration.watches
    end

    def watches=(w)
      Compass.configuration.watches = w
    end
  end

end