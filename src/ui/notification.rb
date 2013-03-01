class  Notification
   NOTIFICATIONS=[]
  def initialize(msg, target_display = nil )
      target_display = App.display unless target_display
      target_display.asyncExec(
        Swt::RRunnable.new do | runnable |
        shell = Swt::Widgets::Shell.new(target_display, Swt::SWT::TOP |Swt::SWT::NO_TRIM)
        NOTIFICATIONS.unshift(shell)
        rowLayout = Swt::Layout::RowLayout.new
        rowLayout.marginLeft   = 10;
        rowLayout.marginTop    = 10;
        rowLayout.marginRight  = 10;
        rowLayout.marginBottom = 10;
        shell.layout = rowLayout

        shell.setBackgroundMode(Swt::SWT::INHERIT_DEFAULT)
        label = Swt::Widgets::Label.new(shell, Swt::SWT::HORIZONTAL )
        label.text = msg

        shell.addListener(Swt::SWT::Resize, Swt::Widgets::Listener.impl do |method, evt|
          # get the size of the drawing area
          rect = shell.getClientArea();
          # create a new image with that size
          newImage = Swt::Graphics::Image.new(target_display, (1> rect.width ? 1 : rect.width), rect.height);
          # create a GC object we can use to draw with
          gc = Swt::Graphics::GC.new(newImage);

          # draw shell edge
          gc.setLineWidth(2);
          gc.setForeground(Swt::Graphics::Color.new(target_display, 0,0,0));
          gc.drawRectangle(rect.x + 1, rect.y + 1, rect.width - 2, rect.height - 2);
          # remember to dispose the GC object!
          gc.dispose();

          # now set the background image on the shell
          shell.setBackgroundImage(newImage)
          
          # to dispose the GC object!
          newImage.dispose
        end)

        m=target_display.getPrimaryMonitor()
        shell.setSize(m.getBounds().width, m.getBounds().height)
        shell.pack
        height = 25
        alpha = 255
        NOTIFICATIONS.each do | s |
          next if s.isDisposed 
        s.setAlpha(alpha)
        s.setLocation( m.getBounds().width - s.getBounds().width , height )
        height = height + s.getBounds().height
        alpha -= 30
        end
        shell.setVisible(true)

        target_display.timerExec(5000, Swt::RRunnable.new do
          shell.dispose
          shell = nil
          NOTIFICATIONS.delete_if{ | x | x.isDisposed }
        end)
      end)
  end

end
