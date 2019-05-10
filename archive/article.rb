# encoding: UTF-8
require 'json'

class Article
	def initialize(chemin)
		@chemin = chemin
		config = File.open("#{@chemin}/config.json"){|i| i.read}
		config = JSON.parse(config)
		@author = config["author"]
		@title = config["title"]
		@subject = config["subject"]
		@key_words = config["key_words"]
		@main = config["main"]
		date = config["date"].split("/").map { |e| e.to_i }
		@date = Time.new(date[2], date[1],  date[0])
	end
end
