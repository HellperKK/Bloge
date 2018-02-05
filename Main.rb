# encoding: UTF-8
require 'fileutils'
require 'json'
require_relative "Article.rb"

args = ARGV
if args != []
	main_dir = args[0]
else
  main_dir = "Test"
end
config = File.open("#{main_dir}/config.json"){|i| i.read}
config = JSON.parse(config)

#articles = Dir["Articles/*"].select{|i|File.directory?(i)}.map { |e| Article.new(e) }

=begin
if File.exist?("Output")
    FileUtils.rm_r("Output")
end
Dir.mkdir("Output")
chemins = Dir["Input/**/*"].select{|i|File.file?(i)}
articles = chemins.select{|i|File.extname(i) == ".txt"}.select{|i|not File.basename(i).include?("#")}
autre = chemins.select{|i|File.extname(i) != ".txt"}
autre.each do |i|
	 new_chem = i.sub("Input", "Output")
	 FileUtils.cp(i, new_chem)
end
articles_objet = articles.map{|i|Article.new(i)}
articles_objet.each do |i|
	f = File.open(i.adresse_finale ,'w')
        f.write(i.to_html)
        f.close
end
articles_objet.sort!{|x, y| y.date <=> x.date}
generateur = regroupe_par(articles_objet, 5)
generateur.map!{|i|AritcilePlus.new(i, generateur.index(i), generateur.length-1)}
generateur.each do |i|
	f = File.open(i.trouveChemin ,'w')
        f.write(i.to_html)
        f.close
end

chemins = Dir["Input/**/*"].select{|i|File.file?(i)}
chemins.each do |i|
    new_chem = i.sub("Input", "Output")
    creerDirectory(File.dirname(new_chem))
    if File.extname(i) == ".txt"
        contenu = to_html(i)
        new_chem = new_chem.sub(".txt", ".html")
        f = File.open(new_chem ,'w')
        f.write(contenu)
        f.close
    else
        FileUtils.cp(i, new_chem)
    end
end

=end
