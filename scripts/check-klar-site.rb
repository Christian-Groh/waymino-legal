#!/usr/bin/env ruby
# frozen_string_literal: true

require "open3"

ROOT = File.expand_path("..", __dir__)
PRODUCTS = %w[rauchklar klinikklar hierklar].freeze
errors = []

def target_file(root, url)
  path = url.split(/[?#]/, 2).first
  relative = path.sub(%r{\A/}, "")
  relative = File.join(relative, "index.html") if relative.empty? || path.end_with?("/")
  File.join(root, relative)
end

PRODUCTS.each do |product|
  homepage = File.join(ROOT, product, "index.html")
  html = File.read(homepage)
  errors << "#{product}: RideRight-Markenhinweis fehlt" unless html.include?("Ein Produkt von RideRight")
  errors << "#{product}: kanonischer Kleinbuchstabenpfad fehlt" unless html.include?(%(<link rel="canonical" href="https://waymino.de/#{product}/">))
end

Dir.glob(File.join(ROOT, "{rauchklar,klinikklar,hierklar}", "**", "*.html")).sort.each do |file|
  html = File.read(file)
  html.scan(/(?:href|src)="([^"]+)"/).flatten.each do |url|
    next unless url.start_with?("/")
    next if url.start_with?("//")

    target = target_file(ROOT, url)
    errors << "#{file.delete_prefix(ROOT + "/")}: fehlendes Ziel #{url}" unless File.file?(target)
  end
end

required = %w[
  rauchklar/index.html rauchklar/support/index.html rauchklar/datenschutz/index.html rauchklar/impressum/index.html
  klinikklar/index.html klinikklar/support/index.html klinikklar/datenschutz/index.html klinikklar/impressum/index.html
  hierklar/index.html hierklar/support/index.html hierklar/datenschutz/index.html hierklar/quellen/index.html hierklar/impressum/index.html
  assets/klar-design.css 404.html
]
required.each { |path| errors << "Pflichtdatei fehlt: #{path}" unless File.file?(File.join(ROOT, path)) }

legal_pages = Dir.glob(File.join(ROOT, "{rauchklar,klinikklar,hierklar}", "{datenschutz,support,impressum,quellen}", "index.html"))
legal_pages.each do |file|
  relative = file.delete_prefix(ROOT + "/")
  before, status = Open3.capture2("git", "show", "klar-family-pre-redesign-20261003:#{relative}", chdir: ROOT)
  next unless status.success?

  previous_main = before[/<main\b.*?<\/main>/m]
  current_main = File.read(file)[/<main\b.*?<\/main>/m]
  errors << "#{relative}: fachlicher/rechtlicher Hauptinhalt wurde verändert" unless previous_main == current_main
end

redirect = File.read(File.join(ROOT, "404.html"))
errors << "404-Weiterleitung korrigiert /kliniklar/ nicht" unless redirect.include?("/kliniklar") && redirect.include?("/klinikklar")
errors << "404-Weiterleitung normalisiert Groß-/Kleinschreibung nicht" unless redirect.include?("toLowerCase")

if errors.empty?
  puts "Klar-Seiten: interne Links, Assets, Pflichtseiten und kanonische Pfade sind gültig."
else
  warn errors.join("\n")
  exit 1
end
