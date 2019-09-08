require "thor"
require "json"
require "fileutils"

def tell_error(error)
  puts error
  exit(0)
end

def save_config(data, path)
  json = JSON.pretty_generate(data)
  File.open(path, "w"){|file| file.write(json)}
end

def load_config(path)
  data = File.open(path, "r"){|file| file.read}
  JSON.load(data)
end

class CLIManager < Thor
  option :name, default: ".", aliases: :n
  option :title, default: "", aliases: :t
  desc "init", "initializes a new project"
  def init()
    name = options[:name]
    if name != "."
      Dir.mkdir(name)
    end

    config = {
      title: options[:title],
      articles: [],
      publications: []
    }
    save_config(config, "#{name}/data.json")

    puts "Blog initialized"
  end

  # option :name, required: true, aliases: :n
  option :title, default: "", aliases: :t
  desc "add NAME", "adds an article"
  def add(name)
    tell_error("Blog data not found") unless File.file?("data.json")
    config = load_config("data.json")
    tell_error("Invalid global data.json") unless config.include?("articles")
    tell_error("Already an article with the name #{name}") if config["articles"].include?(name)
    tell_error("Invalid global data.json") unless config.include?("publications")
    tell_error("Already an article with the name #{name}") if config["publications"].include?(name)

    config["articles"] << name
    save_config(config, "data.json")

    Dir.mkdir(name)
    config = {
      title: options[:title],
      creation_date: Time.now.to_s,
      publication_date: "",
      format: "html"
    }
    save_config(config, "#{name}/data.json")

    puts "Article #{name} added"
  end

  # option :name, required: true, aliases: :n
  desc "delete NAME", "deletes an unpublished article"
  def delete(name)
    tell_error("Blog data not found") unless File.file?("data.json")
    config = load_config("data.json")
    tell_error("Invalid global data.json") unless config.include?("articles")
    tell_error("No article with the name #{name}") unless config["articles"].include?(name)

    puts "Are you sure ? (Y/N)"
    answer = STDIN.gets.chomp
    if answer == "Y"
      config["articles"].delete(name)
      save_config(config, "data.json")
      FileUtils.rm_r(name)
      puts "Article #{name} deleted"
    else
      puts "No article deleted"
    end
  end

  desc "publish NAME", "publish an unpublished article"
  def publish(name)
    tell_error("Blog data not found") unless File.file?("data.json")
    config = load_config("data.json")
    tell_error("Invalid global data.json") unless config.include?("articles")
    tell_error("Invalid global data.json") unless config.include?("publications")
    tell_error("No article with the name #{name}") unless config["articles"].include?(name)
    tell_error("Article data not found") unless File.file?("#{name}/data.json")
    article_config = load_config("#{name}/data.json")
    tell_error("Invalid article data.json") unless article_config.include?("publication_date")

    config["publications"] << name
    config["articles"].delete(name)
    save_config(config, "data.json")

    if article_config["publication_date"] == ""
      article_config["publication_date"] = Time.now.to_s
    end
    save_config(article_config, "#{name}/data.json")

    puts "Article #{name} published"
  end

  desc "unpublish NAME", "unpublish a published article"
  def unpublish(name)
    tell_error("Blog data not found") unless File.file?("data.json")
    config = load_config("data.json")
    tell_error("Invalid global data.json") unless config.include?("articles")
    tell_error("Invalid global data.json") unless config.include?("publications")
    tell_error("No article with the name #{name}") unless config["publications"].include?(name)

    config["articles"] << name
    config["publications"].delete(name)
    save_config(config, "data.json")

    puts "Article #{name} unpublished"
  end
end

CLIManager.start(ARGV)
