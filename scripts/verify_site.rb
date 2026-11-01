#!/usr/bin/env ruby
# Check the built site, including content that could be lost during migration.
require 'nokogiri'
require 'yaml'
require 'uri'
require 'pathname'

root = Pathname.new(ARGV[0] || '_site').expand_path
with_drafts = ARGV.include?('--drafts')
errors = []
def normalized(text)
  text.gsub(/\s+/, ' ').strip
end
def document(root, path)
  Nokogiri::HTML(File.read(root.join(path), encoding: 'UTF-8'))
end
# Intentional updates made after the original content migration.
def current_url(url)
  updates = {
    'https://www.biorxiv.org/content/10.64898/2026.02.18.706454v1' =>
      'https://www.biorxiv.org/content/10.64898/2026.02.18.706454v2'
  }
  updates.fetch(url, url)
end
%w[index.html publications/index.html projects/index.html cv/index.html yoyo/index.html blog/index.html feed.xml sitemap.xml].each do |path|
  errors << "Missing page: #{path}" unless root.join(path).file?
end
abort errors.join("\n") unless errors.empty?

publications = document(root, 'publications/index.html')
projects = document(root, 'projects/index.html')
cv = document(root, 'cv/index.html')
original = Pathname.new('_archive/legacy/_data')
YAML.load_file(original.join('publications.yaml'))['papers'].each do |paper|
  errors << "Missing publication: #{paper['title']}" unless normalized(publications.text).include?(paper['title'])
  url = current_url(paper['paper_pdf'])
  errors << "Missing paper URL: #{url}" unless publications.css('a[href]').any? { |a| a['href'] == url }
end
YAML.load_file(original.join('projects.yaml'))['projects'].each do |project|
  errors << "Missing project: #{project['title']}" unless normalized(projects.text).include?(project['title'])
  url = current_url(project['url'])
  errors << "Missing project URL: #{url}" unless projects.css('a[href]').any? { |a| a['href'] == url }
end
YAML.load_file(original.join('experience.yaml'))['experiences'].each do |entry|
  [entry['place'], entry['title']].each do |text|
    errors << "Missing CV entry: #{text}" unless normalized(cv.text).include?(text)
  end
  detail = normalized(Nokogiri::HTML.fragment(entry['subtitle']).text)
  errors << "Missing CV details: #{entry['place']}" unless normalized(cv.text).include?(detail)
end

html_files = Dir[root.join('**/*.html')]
html_files.each do |file|
  doc = Nokogiri::HTML(File.read(file, encoding: 'UTF-8'))
  doc.css('a[href], img[src], script[src], link[href], iframe[src]').each do |node|
    link = node['href'] || node['src']
    next if link.nil? || link.empty? || link.start_with?('#', '//') || link.match?(/\A[a-z][a-z0-9+.-]*:/i)
    path = URI::DEFAULT_PARSER.unescape(link.split(/[?#]/, 2).first)
    next if path.empty?
    target = path.start_with?('/') ? root.join(path.delete_prefix('/')) : Pathname.new(file).dirname.join(path)
    exists = target.file? || target.join('index.html').file?
    errors << "Broken local link in #{Pathname.new(file).relative_path_from(root)}: #{link}" unless exists
  end
  errors << "Unrendered Liquid: #{file}" if doc.text.match?(/\{%\s*(include|if|for|assign|bibliography|end)/)
end
%w[_archive _website_2014 libs vendor docs scripts].each do |path|
  errors << "Excluded content leaked: #{path}" if root.join(path).exist?
end
starter = Dir[root.join('blog/**/research-post-starter/index.html')]
if with_drafts
  errors << 'Distill starter missing in draft build' if starter.empty?
  unless starter.empty?
    draft = Nokogiri::HTML(File.read(starter.first, encoding: 'UTF-8'))
    %w[d-article d-byline d-cite d-bibliography iframe].each do |tag|
      errors << "Distill feature missing: #{tag}" if draft.css(tag).empty?
    end
    errors << 'MathJax missing' unless draft.css('script[src]').any? { |s| s['src'].include?('tex-mml-chtml') }
  end
else
  errors << 'Unpublished starter leaked into production' unless starter.empty?
  errors << 'Draft leaked into feed' if File.read(root.join('feed.xml')).include?('Research post starter')
end
abort errors.uniq.join("\n") unless errors.empty?
puts "Verified #{html_files.size} HTML pages: migrated content, local links, assets, exclusions#{with_drafts ? ', and Distill features' : ', and draft isolation'}."
