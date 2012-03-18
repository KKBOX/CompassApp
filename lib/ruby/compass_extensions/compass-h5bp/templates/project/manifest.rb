Compass.configuration.javascripts_dir= "js"
Compass.configuration.css_dir= "css"
Compass.configuration.images_dir= "img"

discover :stylesheets

dir = File.dirname(__FILE__)
Dir.glob("#{dir}/**/*").each do |file|
  next if /manifest\.rb/ =~ file
  next if /.*\.scss/ =~ file
  short_name = file[(dir.length+1)..-1]
  options = {}
  ext = if File.extname(short_name) == ".erb"
          options[:erb] = true
          File.extname(short_name[0..-5])
        else
          File.extname(short_name)
        end[1..-1]
        file_type = :file 
        file_type = :directory if File.directory?(file)
        send(file_type, short_name, options)
end 

