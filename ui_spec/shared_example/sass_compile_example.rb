
require File.join(File.dirname(__FILE__), '../ui_spec_helper.rb')

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

      puts sass_dir
      puts css_dir

      %W{enable disable}.each do |line_comments| 
        describe "and option 'line comments' is %s" % line_comments do


          %W{compact compressed expanded nested}.each do |output_style|
            describe "and option 'output style' is %s" % output_style  do


              it "should compile scss/sass to css by 'line comments: %s' & 'output style: %s" % [line_comments, output_style] do

                # -- set line commtents --
                line_comments_item = bot.menu('Change Options...').menu('Line Comments')
                if (line_comments == 'enable' and not line_comments_item.isChecked) or 
                   (line_comments == 'disable' and line_comments_item.isChecked) 
                then
                  line_comments_item.click
                end

                # -- set output style --
                bot.menu('Change Options...').menu(output_style).click

                test_filename = "swt_test"
                source_file = File.join(File.dirname(__FILE__), '../test_data', test_filename+'.scss')
                test_file = File.join(css_dir, test_filename+'.css')
                dist_file = File.join(File.dirname(__FILE__), '../test_data', '%s_line_comments'%line_comments, output_style, test_filename+'.css')

                FileUtils.cp(source_file, sass_dir)
                sleep(3.0)
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


