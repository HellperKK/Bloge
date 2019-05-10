require 'fileutils'
require 'json'

class Bloge
  def initialize(input_path, output_path)
    @input_path = input_path
    @output_path = output_path
    config = File.open("#{@input_path}/config.json", "r"){|file| file.read}
    @config = JSON.parse(config)
    @config.default = ""
  end

  def generate
    format_main
  end

  def format_main
    template = @config["main_template"]
    raise "No template given" if template == ""
    content = File.open("#{@input_path}/#{template}", "r"){|file| file.read}
    content.gsub!(/{[a-z]+}/) do |match|
      name = /([a-z]+)/.match(match)
      @config[name[1]]
    end
    puts content
  end
end

blog = Bloge.new("test/input", "test/output")
blog.generate
