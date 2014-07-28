source_path = File.join( File.dirname(__FILE__), "source")

FileUtils.mkdir_p(Compass.configuration.project_path)

Dir.glob( File.join(source_path, "*") ).each do |x|

  puts "Copy: #{x.sub( source_path, "")}"
  FileUtils.cp_r(x, Compass.configuration.project_path)
end
