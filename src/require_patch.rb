class Object
  def require(ruby_file)
    unless SplashWindow.instance.shell.isDisposed
      SplashWindow.instance.replace("Loading #{ruby_file}") 
    end
    super
  end
end

