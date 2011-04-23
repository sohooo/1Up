#!/usr/bin/ruby

require "rubygems"
require "pathname"

CONFIG_FILE = File.expand_path("../config.yaml", __FILE__)
CONFIG = YAML::load(File.read(CONFIG_FILE))

class OneUp

  def initialize(image)
    @original = Pathname.new image
    @host     = CONFIG["oneup"]["host"]
    @path     = CONFIG["oneup"]["path"]
    @dest     = "#{@host}:#{@path}"
  end

  def convert(img)
    puts "converting " + img
    mogrify = "/usr/local/bin/mogrify"
    system("#{mogrify} -resize x800 -strip #{img}")
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
    %x[#{growl} -v]
    if $?.exitstatus == 0
      notify growl, url
    end
  end

  def notify(growl, url)
    puts "sending growl notification"
    icon = File.expand_path("../icon.png", __FILE__)
    %x[#{growl} -H localhost --image #{icon} -n 1Up -m '1Upped to #{url}']

    sound = File.expand_path("../sound.caf", __FILE__)
    %x[afplay #{sound}]
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
      puts "1Upped!"
  end

end

image = OneUp.new ARGV[0]
image.upit!
