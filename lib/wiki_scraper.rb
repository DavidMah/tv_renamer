require 'nokogiri'
require 'open-uri'

WIKI = "http://www.wikipedia.org"
class WikiScraper
  def retrieve_titles(url, destination = nil)
    data = extract_titles(url)
    write_titles(data, destination)
  end

  def extract_titles(url)
    document = Nokogiri::HTML(open(url))
    document.css('.vevent').map do |episode|
      begin
        columns = episode.children
        id      = columns.first.content
        title   = episode.css('.summary').first.content
        [id, title]
      rescue
        []
      end
    end
  end

  def write_titles(data, destination)
    return if destination.nil?
    output = File.new(destination, "w")
    data.each do |episode|
      output.syswrite "#{episode.join(" - ")}\n"
    end
  end
end
