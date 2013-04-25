require "singleton"
class SplashWindow
  include Singleton
  def initialize(msg="Starting", target_display = nil, &block)
    target_display = Swt::Widgets::Display.get_current unless target_display
      if org.jruby.platform.Platform::IS_MAC
        @shell = Swt::Widgets::Shell.new(target_display, Swt::SWT::BORDER|Swt::SWT::ON_TOP|Swt::SWT::TITLE)
      else
        @shell = Swt::Widgets::Shell.new(target_display, Swt::SWT::BORDER|Swt::SWT::ON_TOP)
      end
      @shell.setText("Compass.app")
      @shell.setBackgroundMode(Swt::SWT::INHERIT_DEFAULT)
      @shell.setSize(400,100)
      layout = Swt::Layout::GridLayout.new
      layout.numColumns = 2;
      @shell.layout = layout

      gridData = Swt::Layout::GridData.new
      gridData.horizontalAlignment = Swt::SWT::LEFT;
      gridData.verticalAlignment = Swt::SWT::CENTER;
      @img_label = Swt::Widgets::Label.new(@shell, Swt::SWT::LEFT)
      img= Swt::Graphics::Image.new( Swt::Widgets::Display.get_current, java.io.FileInputStream.new( File.join(Main.lib_path, 'images', 'icon', '64.png')))

      @img_label.setImage( img )
      @img_label.setLayoutData(gridData)

      gridData = Swt::Layout::GridData.new
      gridData.horizontalAlignment = Swt::Layout::GridData::FILL;
      gridData.verticalAlignment = Swt::SWT::CENTER;
      gridData.grabExcessHorizontalSpace = true;
      gridData.grabExcessVerticalSpace = true;
      @label = Swt::Widgets::Label.new(@shell, Swt::SWT::LEFT)
      @label.setText(msg)
      @label.setLayoutData(gridData)


      @monior=target_display.getPrimaryMonitor().getBounds();
      rect = @shell.getClientArea();
      @shell.setLocation((@monior.width-rect.width) /2, (@monior.height-rect.height) /2) 
      @shell.open
      @shell.forceActive
      @img_label.redraw
      @img_label.update
      @replace_count = 0
  end

  def replace(msg)
    @replace_count += 1
    if @replace_count % 10 ==0
      @label.text = "Loading #{@replace_count} modules..."
      @label.update 
    end
  end

  def dispose
    @shell.dispose
  end

  def shell
    @shell
  end
end
