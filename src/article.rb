require 'json'
require 'pandoc-ruby'

class Article
  attr_reader :path, :title
  def initialize(path, template_path)
    # definit le chemin de l'article
    @path = path

    # charge le template
    template = File.open(template_path, "r"){|file| file.read}

    # charge le fichier config
    config = File.open("#{@path}/config.json", "r"){|file| file.read}
    @config = JSON.parse(config)
    @config.default = ""

    # definit le titre
    @title = @config["title"]

    # charge l'article
    article = File.open("#{@path}/#{@config["article"]}", "r"){|file| file.read}
    article = PandocRuby.convert(article, :from => :markdown, :to => :html)

    # met l'article dans le template et remplacer les "trous"
    @article = template.gsub!("{content}", article)
    @article.gsub!(/{[a-z]+}/) do |match|
      name = /([a-z]+)/.match(match)
      @config[name[1]]
    end
  end
  def generate(input_path, output_path)
    path = @path.sub(input_path, output_path)
    Dir.mkdir(path)
    File.open("#{path}/index.html", "w"){|file| file.write(@article)}
  end
end
