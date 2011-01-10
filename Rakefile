require 'rawr'
require 'app_bundler'
require 'exe_bundler'
require 'yaml'
module Rawr
  class AppBundler
    # monkey patch again, option mac_do_not_generate_plist not work
    def generate_info_plist
      return 
    end
  end
end

namespace :rawr do
  namespace :bundle do
    task :create_packages_dir do
      @packages_dir = File.join(File.dirname(__FILE__), 'packages')
      Dir.mkdir( @packages_dir ) unless File.exists?( @packages_dir )  
    end

    task :write_version_info do
      @revision ||= (%x{git log | head -c 17 | tail -c 10}).strip
      @compile_time ||= Time.now.strftime('%Y%m%d%H%M')
      @update_url = open('update_url').readline.strip if File.exists?("update_url")
      @update_url ||= ''
      File.open "src/compile_version.rb", 'w' do |file|
        file << <<-INFO_ENDL
	module CompileVersion
	REVISION = '#{@revision}'
	COMPILE_TIME = '#{@compile_time}'
  UPDATE_URL = '#{@update_url}'
	end
INFO_ENDL
 	end
    end

    task(:app).clear_prerequisites.clear_actions
    desc "Bundles the jar from rawr:jar into a native Mac OS X application (.app)"
    task :app => ["rawr:bundle:create_packages_dir", "rawr:bundle:write_version_info", "rawr:jar", CONFIG.osx_output_dir ] do
      Rawr::AppBundler.new.deploy CONFIG
      Dir.chdir File.dirname(__FILE__)
      %x{mkdir -p  #{CONFIG.osx_output_dir}/#{CONFIG.project_name}.app/Contents/Resources/swt}
      %x{cp -R lib/swt/swt_osx* #{CONFIG.osx_output_dir}/#{CONFIG.project_name}.app/Contents/Resources/swt}

      %x{cp -R lib/ruby #{CONFIG.osx_output_dir}/#{CONFIG.project_name}.app/Contents/Resources/ruby}
      %x{cp -R lib/images #{CONFIG.osx_output_dir}/#{CONFIG.project_name}.app/Contents/Resources/images}
      %x{cp -R lib/applescript #{CONFIG.osx_output_dir}/#{CONFIG.project_name}.app/Contents/Resources/applescript}    
      Dir.chdir CONFIG.osx_output_dir
      %x{mv #{CONFIG.project_name}.app compass.app;}
      @osx_bundle_file="compass.app.osx.#{@compile_time}-#{@revision}.zip"
      %x{zip -9 -r #{@packages_dir}/#{@osx_bundle_file} compass.app}
      %x{mkdir #{@packages_dir}/osx; cp -R compass.app #{@packages_dir}/osx}
    end
    
    task(:exe).clear_prerequisites.clear_actions
    desc "Bundles the jar from rawr:jar into a native Windows application (.exe)"
    task :exe => ["rawr:bundle:create_packages_dir",  "rawr:bundle:write_version_info", "rawr:jar", CONFIG.windows_output_dir ] do
      Dir.chdir File.dirname(__FILE__)
      %x{mkdir -p package/windows/package/windows} # path for launch4j link fle
      Rawr::ExeBundler.new.deploy CONFIG

      %x{mkdir -p  #{CONFIG.windows_output_dir}/lib/swt}
      %x{cp -R lib/swt/swt_win* #{CONFIG.windows_output_dir}/lib/swt}
      %x{cp -R lib/ruby #{CONFIG.windows_output_dir}/lib}
      %x{cp -R lib/images #{CONFIG.windows_output_dir}/lib}
      %x{mv package/windows/package/windows/*.exe package/windows}
      %x{rm -rf package/windows/package}
      Dir.chdir 'package'
      %x{rm -rf compass.app windows/*.xml; mv windows compass.app}
      @windows_bundle_file="compass.app.windows.#{@compile_time}-#{@revision}.zip"
      %x{zip -9 -r #{@packages_dir}/#{@windows_bundle_file} compass.app}
      %x{mkdir #{@packages_dir}/windows; cp -R compass.app #{@packages_dir}/windows}
    end
    
    desc "Bundles the jar from rawr:jar into a Linux script"
    task :linux => ["rawr:bundle:create_packages_dir", "rawr:bundle:write_version_info", "rawr:jar" ] do
      Dir.chdir File.dirname(__FILE__)
      %x{mkdir -p  package/jar/lib/swt}
      %x{cp -R lib/swt/swt_linux* package/jar/lib/swt}
      %x{cp -R lib/ruby package/jar/lib}
      %x{cp -R lib/images package/jar/lib}
      %x{mv package/jar package/compass.app}
      %x{echo "#!/bin/sh\njava -d32 -client -jar compass-app.jar" > package/compass.app/run.sh}
      %x{chmod +x package/compass.app/run.sh}
      Dir.chdir 'package'
      @linux_bundle_file="compass.app.linux.#{@compile_time}-#{@revision}.zip"
      %x{zip -9 -r #{@packages_dir}/#{@linux_bundle_file} compass.app}
      %x{mkdir #{@packages_dir}/linux; cp -R compass.app #{@packages_dir}/linux}
    end

    desc "Bundles Linux, OSX and Window package"
    task :all do
      Dir.chdir File.dirname(__FILE__)
      %x{rm -rf package/* packages/*}
      Rake::Task['rawr:bundle:app'].invoke

      Rake::Task.tasks.each{|t| t.reenable}
      Dir.chdir File.dirname(__FILE__)
      %x{rm -rf package/*}
      Rake::Task['rawr:bundle:exe'].invoke
      
      Rake::Task.tasks.each{|t| t.reenable}
      Dir.chdir File.dirname(__FILE__)
      %x{rm -rf package/*}
      Rake::Task['rawr:bundle:linux'].invoke
      url_base=File.dirname(@update_url)
      info={ "linux"   => { "compile_version"=> @compile_time, "url"=> File.join(url_base, @linux_bundle_file)  },
             "osx"     => { "compile_version"=> @compile_time, "url"=> File.join(url_base, @osx_bundle_file)    },
             "windows" => { "compile_version"=> @compile_time, "url"=> File.join(url_base, @windows_bundle_file)} }
      open( File.join(@packages_dir,'update.yml'),'w' ) do |f|
        f.write info.to_yaml
      end
    end
  end
end
