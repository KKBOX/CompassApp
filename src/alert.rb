class Alert

  def initialize(msg, target_display = nil)
    target_display = Swt::Widgets::Display.get_current unless target_display
    target_display.asyncExec(
      Swt::RRunnable.new do | runnable |
      shell = Swt::Widgets::Shell.new(target_display, Swt::SWT::DIALOG_TRIM)
      mb=Swt::Widgets::MessageBox.new(shell, Swt::SWT::ICON_INFORMATION|Swt::SWT::OK)
      mb.setMessage(msg)
      mb.open
    end)

  end
end
