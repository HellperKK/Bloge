require 'json'
require 'fileutils'
require 'pandoc-ruby'
require 'date'

class Article
  attr_reader :path, :title, :date
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

    # definit la date
    date = @config["date"]
    date = /(\d{2})\/(\d{2})\/(\d{4})/.match(date)
    raise "wrong date format" unless date
    @date = Date.new(date[3].to_i, date[2].to_i, date[1].to_i)

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

    files = Dir["#{@path}/*"].select{|file| File.file?(file)}
      .select{|file| ! [".json", ".md"].include?(File.extname(file))}
    files.each do |elem|
      FileUtils.cp(elem, elem.sub(@path, path))
    end
  end
end
