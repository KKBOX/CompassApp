require 'fileutils'

extension_name = %w{
  bootstrap-sass
  compass-960-plugin
  compass-h5bp
  compass-normalize
  html5-boilerplate
  susy
}

tmp_dir = 'tmp_ext'
ext_lib_dir = 'lib/ruby/compass_extensions'

puts "fetch gems..."
`gem install -i #{tmp_dir} #{extension_name.join(" ")}`


def parse_ext_version(dir, ext_name)
  `ls #{dir}`.split("\n").reduce({}) do |hash, g|
    ext_name.each do |ext|
      if g =~ /#{ext}/
        hash[ext] = g.split("-")[-1]
      end
    end
    hash
  end
end

lastest_versions = parse_ext_version("#{tmp_dir}/gems", extension_name)
local_versions = parse_ext_version("#{ext_lib_dir}", extension_name)

commits = []
lastest_versions.keys.each do |g|
  local = local_versions[g] || "0"
  lastest = lastest_versions[g]

  if lastest > local
    puts "upgrade #{g} from #{local} to #{lastest}"
    commits << "#{g} #{local} -> #{lastest}"

    FileUtils.rm_rf( "#{ext_lib_dir}/#{g}-#{local}") 
    FileUtils.cp_r( "#{tmp_dir}/gems/#{g}-#{lastest}", "#{ext_lib_dir}" )
  end

end

FileUtils.rm_rf( "#{tmp_dir}" )

if commits.length == 0
  puts "\nAll extensions are the lastest version."
else
  puts "\nCommmit:"
  puts commits.join(", ")
end


