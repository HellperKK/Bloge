require 'json'
require 'pandoc-ruby'

class Article
  def initialize(path, template_path)
    # definit le chemin de l'article
    @path = path

    # charge le template
    @template = File.open(template_path, "r"){|file| file.read}

    # charge le fichier config
    config = File.open("#{@path}/config.json", "r"){|file| file.read}
    @config = JSON.parse(config)
    @config.default = ""

    # charge l'article
    @article = File.open("#{@path}/#{@config["article"]}", "r"){|file| file.read}
    puts PandocRuby.convert(@article, :from => :markdown, :to => :html)
  end
end
