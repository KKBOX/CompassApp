require 'singleton'

class ChangeOptionsPanel
  include Singleton


  def initialize()
    @display = Swt::Widgets::Display.get_current
  end

  def open
    self.create_window if !@shell || @shell.isDisposed
    m=@display.getPrimaryMonitor().getBounds()
    rect = @shell.getClientArea()
    @shell.setLocation((m.width-rect.width) /2, (m.height-rect.height) /2) 
    @shell.open
    @shell.forceActive

    @isChanged = false
  end

  def close
    @shell.dispose if @shell and !@shell.isDisposed
  end

  def close
    @shell.dispose if @shell and !@shell.isDisposed
  end

  def config
    Tray.instance.compass_project_config
  end

  def create_window
    @shell = Swt::Widgets::Shell.new(@display, Swt::SWT::DIALOG_TRIM)
    @shell.setText("Change Options")
    @shell.setBackgroundMode(Swt::SWT::INHERIT_DEFAULT)
   
    layout = Swt::Layout::FormLayout.new
    layout.marginWidth = layout.marginHeight = 15
    @shell.layout = layout

    # -- panel title label --
    panel_title_label = Swt::Widgets::Label.new(@shell, Swt::SWT::LEFT)
    font_data=panel_title_label.getFont().getFontData()
    font_data.each do |fd|
      fd.setStyle(Swt::SWT::BOLD)
      fd.setHeight(14)
    end
    font=Swt::Graphics::Font.new(@display, font_data)
    panel_title_label.setFont(font)
    panel_title_label.setText("Project Options")
    layoutdata = Swt::Layout::FormData.new(390, Swt::SWT::DEFAULT)
    panel_title_label.setLayoutData( layoutdata )

    # -- horizontal separator --
    horizontal_separator = build_separator(panel_title_label)

    # -- context group --
    @general_group = build_general_group(horizontal_separator)
    @sass_group = build_sass_group(@general_group)

    horizontal_separator = build_separator(@sass_group)
    # -- control button --
    build_control_button(horizontal_separator)
    #build_control_button(@less_group)
    
    
    @shell.pack
  end

  def build_separator(align)
    horizontal_separator = Swt::Widgets::Label.new(@shell, Swt::SWT::SEPARATOR | Swt::SWT::HORIZONTAL)
    layoutdata = Swt::Layout::FormData.new(390, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( align, 0, Swt::SWT::LEFT )
    layoutdata.top  = Swt::Layout::FormAttachment.new( align, 10, Swt::SWT::BOTTOM)
    horizontal_separator.setLayoutData( layoutdata )
    horizontal_separator
  end

  def build_basic_group(text, align, to = 'bottom')
    group = Swt::Widgets::Group.new(@shell, Swt::SWT::SHADOW_ETCHED_OUT)
    group.setText(text)

    layoutdata = Swt::Layout::FormData.new(380, Swt::SWT::DEFAULT)
    if to == 'bottom'
      layoutdata.left = Swt::Layout::FormAttachment.new( align, 0, Swt::SWT::LEFT )
      layoutdata.top  = Swt::Layout::FormAttachment.new( align, 10, Swt::SWT::BOTTOM)
    elsif to == 'right'
      layoutdata.left = Swt::Layout::FormAttachment.new( align, 8, Swt::SWT::RIGHT )
      layoutdata.top  = Swt::Layout::FormAttachment.new( align, 0, Swt::SWT::TOP)
    end
    group.setLayoutData( layoutdata )

    layout = Swt::Layout::FormLayout.new
    layout.marginWidth = layout.marginHeight = 5
    group.setLayout( layout )
    group

  end

  def build_dir_label_on_general_group(group, text, align)
    dir_label = Swt::Widgets::Label.new(group, Swt::SWT::PUSH)
    layoutdata = Swt::Layout::FormData.new(120, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( align, 0, Swt::SWT::LEFT )
    layoutdata.top  = Swt::Layout::FormAttachment.new( align, 10, Swt::SWT::BOTTOM)
    dir_label.setLayoutData( layoutdata )
    dir_label.setText(text)
    dir_label.pack
    dir_label
  end

  def build_dir_text_on_general_group(group, text, align, size = 180)
    layoutdata = Swt::Layout::FormData.new(size, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( align, 1, Swt::SWT::RIGHT)
    layoutdata.top  = Swt::Layout::FormAttachment.new( align, 0, Swt::SWT::CENTER)
    dir_text  = Swt::Widgets::Text.new(group, Swt::SWT::BORDER)
    dir_text.setLayoutData( layoutdata )
    dir_text.setText( text ) if text
    dir_text.addListener(Swt::SWT::Modify, change_handler)
    dir_text
  end

  def build_select_button_on_general_group(group, swttext, align = nil)
    # -- dir button --
    align = swttext if align
    select_dir_btn = Swt::Widgets::Button.new(group, Swt::SWT::PUSH | Swt::SWT::CENTER)
    select_dir_btn.setText('Select')
    button_width = 70
    button_width = button_width - 10 if org.jruby.platform.Platform::IS_WINDOWS
    layoutdata = Swt::Layout::FormData.new(button_width, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( swttext, 1, Swt::SWT::RIGHT)
    layoutdata.top  = Swt::Layout::FormAttachment.new( swttext, 0, Swt::SWT::CENTER)
    select_dir_btn.setLayoutData( layoutdata )
    select_dir_btn.addListener(Swt::SWT::Selection, select_handler(swttext))
    select_dir_btn
  end

  def build_checkbox_button(group, text, selected, align = nil)
    layoutdata = Swt::Layout::FormData.new(350, Swt::SWT::DEFAULT)
    if align != nil
        layoutdata.left = Swt::Layout::FormAttachment.new( align, 0, Swt::SWT::LEFT )
        layoutdata.top  = Swt::Layout::FormAttachment.new( align, 10, Swt::SWT::BOTTOM)
    end
    checkbox_button = Swt::Widgets::Button.new(group, Swt::SWT::CHECK )
    checkbox_button.setText( text )
    checkbox_button.setLayoutData( layoutdata )
    checkbox_button.setSelection(true) if selected
    checkbox_button.addListener(Swt::SWT::Selection, change_handler)
    
    checkbox_button
  end

  def build_general_group(behind)
    group = build_basic_group('General', behind)

    # -- sass dir --
    sass_dir_label = build_dir_label_on_general_group(group, "Sass Folder", group)
    @sass_dir_text = build_dir_text_on_general_group(group, config.sass_dir, sass_dir_label)
    build_select_button_on_general_group(group, @sass_dir_text)

    # -- css dir --
    css_dir_label = build_dir_label_on_general_group(group, "CSS Folder", sass_dir_label)
    @css_dir_text = build_dir_text_on_general_group(group, config.css_dir, css_dir_label)
    build_select_button_on_general_group(group, @css_dir_text)

    # -- images dir --
    images_dir_label = build_dir_label_on_general_group(group, "Image Folder", css_dir_label)
    @images_dir_text = build_dir_text_on_general_group(group, config.images_dir, images_dir_label)
    build_select_button_on_general_group(group, @images_dir_text)

    group.pack

    group
  end

  def build_sass_group(behind)
    group = build_basic_group('Sass', behind)

    # -- output style label -- 
    output_style_label = Swt::Widgets::Label.new(group, Swt::SWT::PUSH)
    output_style_label.setText("Output Style:")
    output_style_label.pack

    # -- output style combo --
    layoutdata = Swt::Layout::FormData.new(100, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( output_style_label, 1, Swt::SWT::RIGHT)
    layoutdata.top  = Swt::Layout::FormAttachment.new( output_style_label, 0, Swt::SWT::CENTER)
    @output_style_combo  = Swt::Widgets::Combo.new(group, Swt::SWT::DEFAULT)
    @output_style_combo.setLayoutData( layoutdata )
    %W{nested expanded compact compressed}.each do |output_style|
      @output_style_combo.add(output_style)
    end
    @output_style_combo.setText( config.output_style.to_s )
    @output_style_combo.addListener(Swt::SWT::Selection, change_handler)

    @relative_assets_button = build_checkbox_button(group, 'Relative Assets', config.relative_assets, output_style_label)

    # -- line comments checkbox --
    @line_comments_button = build_checkbox_button(group, 'Line Comments', config.line_comments, @relative_assets_button)

    # -- debug info checkbox --
    @debug_info_button = build_checkbox_button(group, 'Debug Info', config.sass_options && config.sass_options[:debug_info],  @line_comments_button)


    # -- sourcemap checkbox --
    if App::CONFIG['use_version'] == 1.0
        @sourcemap_button = build_checkbox_button(group, 'Enable Sourcemap', config.sourcemap,  @debug_info_button)
    end

    group.pack

    group
  end

  def build_control_button(behind)

    button_width = 90
    button_width = button_width - 10 if org.jruby.platform.Platform::IS_WINDOWS

    # -- save button --
    save_btn = Swt::Widgets::Button.new(@shell, Swt::SWT::PUSH | Swt::SWT::CENTER)
    save_btn.setText('Save')
    layoutdata = Swt::Layout::FormData.new(button_width, Swt::SWT::DEFAULT)
    layoutdata.right = Swt::Layout::FormAttachment.new( behind, 0, Swt::SWT::RIGHT)
    layoutdata.top  = Swt::Layout::FormAttachment.new( behind, 10, Swt::SWT::BOTTOM)
    save_btn.setLayoutData( layoutdata )
    save_btn.addListener(Swt::SWT::Selection, save_handler)
    save_btn.pack

    # -- cancel button --
    cancel_btn = Swt::Widgets::Button.new(@shell, Swt::SWT::PUSH | Swt::SWT::CENTER)
    cancel_btn.setText('Cancel')
    layoutdata = Swt::Layout::FormData.new(button_width, Swt::SWT::DEFAULT)
    layoutdata.right = Swt::Layout::FormAttachment.new( save_btn, 5, Swt::SWT::LEFT)
    layoutdata.right = Swt::Layout::FormAttachment.new( save_btn, -5, Swt::SWT::LEFT) if org.jruby.platform.Platform::IS_WINDOWS
    layoutdata.top  = Swt::Layout::FormAttachment.new( save_btn, 0, Swt::SWT::CENTER)
    cancel_btn.setLayoutData( layoutdata )
    cancel_btn.addListener(Swt::SWT::Selection, cancel_handler)
    cancel_btn.pack
  end


  def change_handler
    Swt::Widgets::Listener.impl do |method, evt|   
      @isChanged = true
    end
  end

  def cancel_handler
    Swt::Widgets::Listener.impl do |method, evt|   
      close
    end
  end

  def select_handler(swttext)
    Swt::Widgets::Listener.impl do |method, evt|   
      dia = Swt::Widgets::DirectoryDialog.new(@shell)
      dia.setFilterPath(Tray.instance.watching_dir)
      dir = dia.open
      dir_path = Pathname.new(dir) if !dir.nil? 
      watching_dir_path = Pathname.new(Tray.instance.watching_dir)

      if dir.nil? || dir_path.realpath == watching_dir_path.realpath then
        nil
      elsif !dir_path.relative_path_from(watching_dir_path).to_s.split('/').include?('..') 
        swttext.setText(dir_path.relative_path_from(watching_dir_path).to_s) 
        swttext.forceFocus
      else
        App.alert("Can't use this folder.")
      end
    end
  end

  def save_handler
    Swt::Widgets::Listener.impl do |method, evt|
      evt.widget.shell.setVisible( false )

      if @isChanged
        msg_window = ProgressWindow.new
        msg_window.replace('Regenerating...', false, true)

        # -- update general --
        # Tray.instance.update_config( "http_path", @http_path_text.getText.inspect )
        Tray.instance.update_config( "css_dir", @css_dir_text.getText.inspect )
        Tray.instance.update_config( "sass_dir", @sass_dir_text.getText.inspect )
        Tray.instance.update_config( "images_dir", @images_dir_text.getText.inspect )

        # -- update output style --
        Tray.instance.update_config( "output_style", ":"+@output_style_combo.getItem(@output_style_combo.getSelectionIndex).to_s )

        # -- relative_assets --
        Tray.instance.update_config( "relative_assets", @relative_assets_button.getSelection )

        # -- update line comments --
        Tray.instance.update_config( "line_comments", @line_comments_button.getSelection )

        # -- update sass options --
        sass_options = config.sass_options
        sass_options = {} if !sass_options.is_a? Hash
        sass_options[:debug_info] = @debug_info_button.getSelection
        Tray.instance.update_config( "sass_options", sass_options.inspect )

        

        # -- update sourcemap options --
        if App::CONFIG['use_version'] == 1.0
            Tray.instance.update_config( "sourcemap", @sourcemap_button.getSelection )
        end

        

        Tray.instance.clean_project

        msg_window.dispose
      end

      close
    end
  end

  

end
