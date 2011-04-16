#!/usr/bin/ruby

require "rubygems"
require "pathname"

CONFIG_FILE = File.expand_path("../config.yaml", __FILE__)
CONFIG = YAML::load(File.read(CONFIG_FILE))

class OneUp

  def initialize
    @imagebox = Pathname.new(CONFIG["oneup"]["source"])
    @host     = CONFIG["oneup"]["host"]
    @path     = CONFIG["oneup"]["path"]
    @dest     = "#{@host}:#{@path}"
    @original = get_image
  end

  def get_image
    @imagebox.children.each do |entry|
      next unless entry.file?
      return Pathname.new entry
    end
  end

  def convert(img)
    puts "converting " + img
    system("mogrify -resize x800 -strip #{img}")
  end
  
  def upload(img)
    puts "uploading #{img} to #{@dest}"
    system("scp", img, @dest)

    puts "settings permissions for " + img
    system("ssh #{@host} 'chmod 644 #{@path}/#{@image.basename}'")
  end

  def copy_url
    url = "http://sohooo.at/#{@image.basename}"
    system("echo #{url} | pbcopy")
    puts "copied url " + url

    growl = "/usr/local/bin/growlnotify"
    system(growl, "-v")
    if $?.exitstatus == 0
      notify growl, url
    end
  end

  def notify(growl, url)
    puts "sending growl notification"
    system("#{growl} -H localhost --image icon.png -n 1Up -m '1Upped to #{url}'")
  end

  def backup(file)
    puts "backup file to #{@imagebox + 'backup'}"
    FileUtils.mv file, @imagebox + "backup"
  end

  def in_tempdir
    path = Pathname.new("/tmp/.1up-#{Process.pid}")
    path.mkdir unless path.directory?
    yield path
    path.rmtree
  end

  def upit!
    in_tempdir do |tmp|
      @image = tmp + @original.basename.to_s.downcase

      FileUtils.cp @original, @image
      convert @image
      upload @image
    end

      copy_url
      backup @original
      puts "1Upped!"
  end

end

image = OneUp.new
image.upit!
