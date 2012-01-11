require 'nokogiri'
require 'open-uri'
require 'json'
require 'yaml'

WIKI = "http://www.wikipedia.org"
class WikiScraper

  def scrape(*arguments)
    retrieve_titles(*arguments)
  end

  def retrieve_titles(options = {})
    url = options['arguments'].first
    data = extract_titles(url, options)
    write_titles(data, options)
  end

  def extract_titles(url, options = {})
    document = Nokogiri::HTML(open(url))
    document.css('.vevent').map do |episode|
      begin
        columns = episode.children
        id      = columns.first.content
        title   = episode.css('.summary').first.content
        title.gsub("\"", "")
      rescue
        []
      end
    end
  end

  def write_titles(data, options = {})
    destination = options['output']
    format      = options['format'] || 'json'

    output = (destination ? File.new(destination, "w") : $stdout)
    formatted_data = data.send("to_#{format}")
    if not data.empty?
      output.print(formatted_data)
    else
      output.print("Couldn't Find Any episodes -- page is formatted differently")
    end
    output.print("\n")
  end
end
