require 'tmpdir'
require 'fileutils'
class LockFile

  def initialize
    @filename = 'lock.txt'
    @path = Dir.tmpdir

    FileUtils.touch File.join(@path, @filename) rescue nil
  end

  def close
    FileUtils.rm File.join(@path, @filename) rescue nil
  end

end
