SWT_LIB_PATH ="#{LIB_PATH}/swt"
if org.jruby.platform.Platform::IS_MAC  
  if org.jruby.platform.Platform::ARCH == 'x86_64'
    require "#{SWT_LIB_PATH}/swt_osx64"
  else
    require "#{SWT_LIB_PATH}/swt_osx32"
  end
elsif org.jruby.platform.Platform::IS_LINUX 
  if org.jruby.platform.Platform::ARCH == 'amd64'
    require "#{SWT_LIB_PATH}/swt_linux64"
  else
    require "#{SWT_LIB_PATH}/swt_linux32"
  end
elsif org.jruby.platform.Platform::IS_WINDOWS 
  require "#{SWT_LIB_PATH}/swt_win32"
end

module Swt
  import org.eclipse.swt.SWT
  import org.eclipse.swt.program.Program

  module Widgets
    import org.eclipse.swt.widgets.Button
    import org.eclipse.swt.widgets.Caret
    import org.eclipse.swt.widgets.Combo
    import org.eclipse.swt.widgets.Composite
    import org.eclipse.swt.widgets.Display
    import org.eclipse.swt.widgets.Listener
    import org.eclipse.swt.widgets.Event
    import org.eclipse.swt.widgets.DirectoryDialog
    import org.eclipse.swt.widgets.FileDialog
    import org.eclipse.swt.widgets.Group
    import org.eclipse.swt.widgets.Label
    import org.eclipse.swt.widgets.Link
    import org.eclipse.swt.widgets.List
    import org.eclipse.swt.widgets.Menu
    import org.eclipse.swt.widgets.MenuItem
    import org.eclipse.swt.widgets.MessageBox
    import org.eclipse.swt.widgets.ProgressBar
    import org.eclipse.swt.widgets.Shell
    import org.eclipse.swt.widgets.TabFolder
    import org.eclipse.swt.widgets.TabItem
    import org.eclipse.swt.widgets.Text
    import org.eclipse.swt.widgets.ToolTip
    import org.eclipse.swt.widgets.TrayItem
  end

  def self.display
    if defined?(SWT_APP_NAME)
      Swt::Widgets::Display.app_name = SWT_APP_NAME
    end
    @display ||= (Swt::Widgets::Display.getCurrent || Swt::Widgets::Display.new)
  end

  display # must be created before we import the Clipboard class.

  module Custom
    import org.eclipse.swt.custom.CTabFolder
    import org.eclipse.swt.custom.CTabItem
    import org.eclipse.swt.custom.SashForm
    import org.eclipse.swt.custom.StackLayout
    import org.eclipse.swt.custom.ST
  end

  module DND
    import org.eclipse.swt.dnd.Clipboard
    import org.eclipse.swt.dnd.Transfer
    import org.eclipse.swt.dnd.TextTransfer
  end

  module Layout
    import org.eclipse.swt.layout.FormLayout
    import org.eclipse.swt.layout.FormData
    import org.eclipse.swt.layout.FormAttachment
    import org.eclipse.swt.layout.FillLayout
    import org.eclipse.swt.layout.GridLayout
    import org.eclipse.swt.layout.GridData
    import org.eclipse.swt.layout.RowLayout
    import org.eclipse.swt.layout.RowData
  end

  module Graphics
    import org.eclipse.swt.graphics.Color
    import org.eclipse.swt.graphics.Font
    import org.eclipse.swt.graphics.FontData
    import org.eclipse.swt.graphics.GC
    import org.eclipse.swt.graphics.Image
    import org.eclipse.swt.graphics.Point
    import org.eclipse.swt.graphics.Region
  end

  module Events
    import org.eclipse.swt.events.KeyEvent
  end

  import org.eclipse.swt.browser.Browser
  class Browser
    import org.eclipse.swt.browser.BrowserFunction
  end

  class RRunnable
    include java.lang.Runnable

    def initialize(&block)
      @block = block
    end

    def run
      @block.call
    end
  end
end
