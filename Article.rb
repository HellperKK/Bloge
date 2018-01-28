# encoding: UTF-8
class Article
	def initialize(chemin)
		@chemin = chemin
		@main = File.open("#{@chemin}/main.html")
	end
end