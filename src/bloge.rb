require 'fileutils'
require 'json'

require_relative 'article'

class Bloge
  def initialize(input_path, output_path)
    # recupere les chemins in et out
    @input_path = input_path
    @output_path = output_path

    # charge le fichier config
    config = File.open("#{@input_path}/config.json", "r"){|file| file.read}
    @config = JSON.parse(config)
    @config.default = ""

    # charge les articles
    @articles = Dir["#{@input_path}/#{@config["articles"]}/*"]
      .map{|path| Article.new(path, "#{@input_path}/#{@config["article_template"]}")}
    # puts @articles.to_s
  end

  def generate
    format_main
  end

  def format_main
    # charge le template et lance une exception s'il n'y a pas de nom
    template = @config["main_template"]
    raise "No template given" if template == ""
    content = File.open("#{@input_path}/#{template}", "r"){|file| file.read}

    # remplace les "trous" du template
    content.gsub!("{title}",  @config["title"])
    content.gsub!(/{[a-z]+}/) do |match|
      name = /([a-z]+)/.match(match)
      @config[name[1]]
    end
    # File.open("Bidon.html", "w"){|file| file.write(content)}
  end
end

blog = Bloge.new("test/input", "test/output")
blog.generate
