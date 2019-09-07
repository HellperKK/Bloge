require "thor"
require "json"
require "fileutils"

def tell_error(error)
  puts error
  exit(0)
end

def save_config(data, path)
  json = JSON.generate(data)
  File.open(path, "w"){|file| file.write(json)}
end

def load_config(path)
  data = File.open(path, "r"){|file| file.read}
  JSON.load(data)
end

class CLIManager < Thor
  option :name, default: ".", aliases: :n
  option :title, required: true, aliases: :t
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
  end

  option :name, required: true, aliases: :n
  option :title, required: true, aliases: :t
  desc "add", "adds an article"
  def add()
    name = options[:name]
    tell_error("Blog data not found") unless File.file?("data.json")
    config = load_config("data.json")
    tell_error("Invalid global data.json") unless config.include?("articles")
    tell_error("Already an article with the name #{name}") if config["articles"].include?(name)
    config["articles"] << name
    save_config(config, "data.json")
    Dir.mkdir(name)
    config = {
      title: options[:title],
      creation_date: Time.now.to_s
    }
    save_config(JSON.generate(config), "#{name}/data.json")
  end

  option :name, required: true, aliases: :n
  desc "delete", "removes an unpublished article"
  def delete()
    name = options[:name]
    tell_error("Blog data not found") unless File.file?("data.json")
    config = load_config("data.json")
    tell_error("Invalid global data.json") unless config.include?("articles")
    tell_error("No article article with the name #{name}") unless config["articles"].include?(name)
    puts "Are you sure ? (Y/N)"
    answer = STDIN.gets.chomp
    if answer == "Y"
      config["articles"].delete(name)
      save_config(config, "data.json")
      FileUtils.rm_r(name)
    end
  end
end

CLIManager.start(ARGV)
