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

    @content = ""
  end

  def generate
    # detruit le repertoire de destination s'il existe
    if File.directory?(@output_path)
      FileUtils.rm_r(@output_path)
    end

    # cree le repertoire de destination
    Dir.mkdir(@output_path)
    Dir.mkdir("#{@output_path}/articles")
    Dir.mkdir("#{@output_path}/ressources")
    FileUtils.cp("#{@input_path}/ressources/style.css", "#{@output_path}/ressources/style.css")

    # cree le fichier principal
    format_main
    File.open("#{@output_path}/index.html", "w"){|file| file.write(@content)}

    @articles.each{|article| article.generate(@input_path, @output_path)}
  end

  def format_main
    # charge le template et lance une exception s'il n'y a pas de nom
    template = @config["main_template"]
    raise "No template given" if template == ""
    @content = File.open("#{@input_path}/#{template}", "r"){|file| file.read}

    # met les liens des articles
    format_links

    # remplace les "trous" du template
    @content.gsub!(/{[a-z]+}/) do |match|
      name = /([a-z]+)/.match(match)
      @config[name[1]]
    end
  end

  def format_links
    # cree les liens vers les articles
    links = @articles.sort{|fst, snd| fst.date <=> snd.date}.map do |i|
      out = i.path.sub("#{@input_path}", ".")
      "<a href='#{out}'>#{i.title}</a>"
    end.join("\n<br>\n")
    @content.gsub!("{links}",  links)
  end
end

args = ARGV
raise "Not enough arguments" if args.length < 2

blog = Bloge.new(args[0], args[1])
blog.generate
