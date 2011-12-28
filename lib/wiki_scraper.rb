require 'nokogiri'
require 'open-uri'

WIKI = "http://www.wikipedia.org"
class WikiScraper

  def scrape(*arguments)
    retrieve_titles(*arguments)
  end

  def retrieve_titles(url, logfile = nil)
    data = extract_titles(url)
    write_titles(data, logfile)
    data
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
    output = File.new(destination, "w") if destination
    data.each do |episode|
      formatted_episode = "#{episode.join(" - ")}\n"
      if destination.nil?
        print formatted_episode
      else
        output.syswrite formatted_episode
      end
    end
  end
end
