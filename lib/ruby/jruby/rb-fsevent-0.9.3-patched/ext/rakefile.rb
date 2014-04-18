require 'rubygems' unless defined?(Gem)
require 'pathname'
require 'date'
require 'time'


raise "unable to find xcodebuild" unless system('which', 'xcodebuild')

FSEVENT_WATCH_EXE_VERSION = '0.1.3'


$this_dir = Pathname.new(__FILE__).dirname.expand_path
$final_exe = $this_dir.parent.join('bin/fsevent_watch')

$src_dir = $this_dir.join('fsevent_watch')
$obj_dir = $this_dir.join('build')

SRC = Pathname.glob("#{$src_dir}/*.c")
OBJ = SRC.map {|s| $obj_dir.join("#{s.basename('.c')}.o")}


$now = DateTime.now.xmlschema rescue Time.now.xmlschema

$CC = ENV['CC'] || `which clang || which gcc`.strip
$CFLAGS = ENV['CFLAGS'] || '-fconstant-cfstrings -fstrict-aliasing -funroll-loops'
$ARCHFLAGS = ENV['ARCHFLAGS'] || '-arch x86_64 -arch i386'
$DEFINES = "-DNS_BUILD_32_LIKE_64 -DNS_BLOCK_ASSERTIONS -DOS_OBJECT_USE_OBJC=0 -DPROJECT_VERSION=#{FSEVENT_WATCH_EXE_VERSION}"

$GCC_C_LANGUAGE_STANDARD = 'gnu99'
$CODE_SIGN_IDENTITY = 'Developer ID Application'

$arch = `uname -m`.strip
$os_release = `uname -r`.strip
$BUILD_TRIPLE = "#{$arch}-apple-darwin#{$os_release}"



task :sw_vers do
  $mac_product_version = `sw_vers -productVersion`.strip
  $mac_build_version = `sw_vers -buildVersion`.strip
  $MACOSX_DEPLOYMENT_TARGET = ENV['MACOSX_DEPLOYMENT_TARGET'] || $mac_product_version.sub(/\.\d*$/, '')
  $CFLAGS = "#{$CFLAGS} -mmacosx-version-min=#{$MACOSX_DEPLOYMENT_TARGET}"
end

task :get_sdk_info => :sw_vers do
  $SDK_INFO = {}
  version_info = `xcodebuild -version -sdk macosx#{$MACOSX_DEPLOYMENT_TARGET}`
  raise "invalid SDK" unless !!$?.exitstatus
  version_info.strip.each_line do |line|
    next if line.strip.empty?
    next unless line.include?(':')
    match = line.match(/([^:]*): (.*)/)
    next unless match
    $SDK_INFO[match[1]] = match[2]
  end
end

task :debug => :sw_vers do
  $DEFINES = "-DDEBUG #{$DEFINES}"
  $CFLAGS = "#{$CFLAGS} -O0 -fno-omit-frame-pointer -g"
end

task :release => :sw_vers do
  $DEFINES = "-DNDEBUG #{$DEFINES}"
  $CFLAGS = "#{$CFLAGS} -O3"
end

desc 'configure build type depending on whether ENV var FWDEBUG is set'
task :set_build_type => :sw_vers do
  if ENV['FWDEBUG']
    Rake::Task[:debug].invoke
  else
    Rake::Task[:release].invoke
  end
end

desc 'set build arch to ppc'
task :ppc do
  $ARCHFLAGS = '-arch ppc'
end

desc 'set build arch to x86_64'
task :x86_64 do
  $ARCHFLAGS = '-arch x86_64'
end

desc 'set build arch to i386'
task :x86 do
  $ARCHFLAGS = '-arch i386'
end

task :setup_env => [:set_build_type, :sw_vers, :get_sdk_info]

directory $obj_dir.to_s
file $obj_dir.to_s => :setup_env

SRC.zip(OBJ).each do |source, object|
  file object.to_s => [source.to_s, $obj_dir.to_s] do
    cmd = [
      $CC,
      $ARCHFLAGS,
      "-std=#{$GCC_C_LANGUAGE_STANDARD}",
      $CFLAGS,
      $DEFINES,
      "-I#{$src_dir}",
      '-isysroot',
      $SDK_INFO['Path'],
      '-c', source,
      '-o', object
    ]
    sh(cmd.map {|s| s.to_s}.join(' '))
  end
end

desc 'generate an Info.plist used for code signing as well as embedding build settings into the resulting binary'
file $obj_dir.join('Info.plist').to_s => [$obj_dir.to_s, :setup_env] do
  File.open($obj_dir.join('Info.plist').to_s, 'w+') do |file|
    file << '<?xml version="1.0" encoding="UTF-8"?>'
    file << '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">'
    file << '<plist version="1.0">'
    file << '<dict>'

    file << '<key>CFBundleExecutable</key>'
    file << '<string>fsevent_watch</string>'
    file << '<key>CFBundleIdentifier</key>'
    file << '<string>com.teaspoonofinsanity.fsevent_watch</string>'
    file << '<key>CFBundleName</key>'
    file << '<string>fsevent_watch</string>'

    file << '<key>CFBundleVersion</key>'
    file << "<string>#{FSEVENT_WATCH_EXE_VERSION}</string>"
    file << '<key>LSMinimumSystemVersion</key>'
    file << "<string>#{$MACOSX_DEPLOYMENT_TARGET}</string>"
    file << '<key>DTSDKBuild</key>'
    file << "<string>#{$SDK_INFO['ProductBuildVersion']}</string>"
    file << '<key>DTSDKName</key>'
    file << "<string>macosx#{$SDK_INFO['SDKVersion']}</string>"
    file << '<key>BuildMachineOSBuild</key>'
    file << "<string>#{$mac_build_version}</string>"
    file << '<key>BuildMachineOSVersion</key>'
    file << "<string>#{$mac_product_version}</string>"
    file << '<key>FSEWCompiledAt</key>'
    file << "<string>#{$now}</string>"
    file << '<key>FSEWVersionInfoBuilder</key>'
    file << "<string>#{`whoami`.strip}</string>"
    file << '<key>FSEWBuildTriple</key>'
    file << "<string>#{$BUILD_TRIPLE}</string>"
    file << '<key>FSEWCC</key>'
    file << "<string>#{$CC}</string>"
    file << '<key>FSEWCFLAGS</key>'
    file << "<string>#{$CFLAGS}</string>"

    file << '</dict>'
    file << '</plist>'
  end
end

file $obj_dir.join('fsevent_watch').to_s => [$obj_dir.to_s, $obj_dir.join('Info.plist').to_s] + OBJ.map(&:to_s) do
  cmd = [
    $CC,
    $ARCHFLAGS,
    "-std=#{$GCC_C_LANGUAGE_STANDARD}",
    $CFLAGS,
    $DEFINES,
    "-I#{$src_dir}",
    '-isysroot',
    $SDK_INFO['Path'],
    '-framework CoreFoundation -framework CoreServices',
    '-sectcreate __TEXT __info_plist',
    $obj_dir.join('Info.plist')
  ] + OBJ + [
    '-o', $obj_dir.join('fsevent_watch')
  ]
  sh(cmd.map {|s| s.to_s}.join(' '))
end

desc 'compile and link build/fsevent_watch'
task :build => $obj_dir.join('fsevent_watch').to_s

desc 'codesign build/fsevent_watch binary'
task :codesign => :build do
  sh "codesign -s '#{$CODE_SIGN_IDENTITY}' #{$obj_dir.join('fsevent_watch')}"
end

desc 'replace bundled fsevent_watch binary with build/fsevent_watch'
task :replace_exe => :build do
  sh "mv #{$obj_dir.join('fsevent_watch')} #{$final_exe}"
end

task :default => :replace_exe

