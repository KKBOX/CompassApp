
shared_examples_for "sass_compile_example" do
  
  bot = SwtBot.new(Tray.instance.shell, Tray.instance.menu)

  describe "when trigger 'Watch Compass Project'" do
    #before(:all) do
    #  it "should Watch Compass Project" do
    #    bot.menu('Watch a Folder...').click.should be_nil
    #  end
    #end

    bot.menu('Watch a Folder...').click

    describe "and put a .scss file into sass dir" do
      sass_dir = File.join(Swt::Widgets::DirectoryDialog.open_path, Tray.instance.compass_project_config.sass_dir)
      css_dir = File.join(Swt::Widgets::DirectoryDialog.open_path, Tray.instance.compass_project_config.css_dir)

      %W{enable disable}.each do |relative_assets| 
        describe "and option 'relative assets=%s'" % relative_assets do

          %W{enable disable}.each do |line_comments| 
            describe "and option 'line comments=%s'" % line_comments do

              %W{disable}.each do |debug_info| 
                describe "and option 'debug info=%s'" % debug_info do

                  %W{compact compressed expanded nested}.each do |output_style|
                    describe "and option 'output style=%s'" % output_style  do

                      it "should compile scss/sass to css" do

                        test_filename = "swt_test"
                        source_file = File.join(File.dirname(__FILE__), '../test_data/sass', test_filename+'.scss')
                        test_file = File.join(css_dir, test_filename+'.css')
                        dist_file = File.join(File.dirname(__FILE__), '../test_data/%s_relative_assets/%s_line_comments/%s_debug_info/%s/%s.css' % [relative_assets, line_comments, debug_info, output_style, test_filename])

                        FileUtils.rm_rf(sass_dir)
                        FileUtils.mkdir_p(sass_dir)
                        FileUtils.cp_r(source_file, sass_dir)

                        # -- open change options panel --
                        bot.menu('Change Options...').click
                        change_panel_bot = SwtBot.new(bot.shell('Change Options').widget, Tray.instance.menu)

                        puts "Change Options"

                        # -- set relative assets --
                        change_panel_bot.checkBox('Relative Assets').select if relative_assets == 'enable'
                        change_panel_bot.checkBox('Relative Assets').deselect if relative_assets == 'disable'

                        # -- set line commtents --
                        change_panel_bot.checkBox('Line Comments').select if line_comments == 'enable'
                        change_panel_bot.checkBox('Line Comments').deselect if line_comments == 'disable'

                        # -- set relative assets --
                        change_panel_bot.checkBox('Debug Info').select if debug_info == 'enable'
                        change_panel_bot.checkBox('Debug Info').deselect if debug_info == 'disable'

                        # -- set output style --
                        change_panel_bot.comboBoxInGroup('Sass').setSelection(output_style)

                        # -- save --
                        change_panel_bot.button('Save').click

                        puts Pathname.new(test_file).realpath
                        puts File.read(test_file)
                        puts Pathname.new(dist_file).realpath
                        puts File.read(dist_file)
                        #sleep(3.0)
                        FileUtils.compare_file(test_file, dist_file).should be_true


                        #puts source_file
                        #puts test_file
                        #puts dist_file
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end 

#bot.menu('Quit').click

=begin
bot = SwtBot.new(Tray.instance.shell, Tray.instance.menu)





#bot.menu('Watch a Folder...').click
#bot.menu('Create Compass Project').menu('blueprint').menu('buttons').click

#puts Tray.instance.dialog



Compass::Frameworks::ALL.each do | framework |
  next if framework.name =~ /^_/
  next if framework.template_directories.empty?
  #puts framework.name
  framework.template_directories.each do | dir |
    #puts "  "+dir.to_s
  end
end


#describe Main do
  #when "create project ''" do
    #it "" do
    #end
  #end
#end
=end


#Main.run_tray


