require 'wiki_scraper'
require 'title_writer'
require 'title_describer'

class TvInterface
  def initialize
    @wiki_scraper   = WikiScraper.new
    @title_writer   = TitleWriter.new
    @title_describer = TitleDescriber.new
    @tools        = {'scrape'   => @wiki_scraper,
                     'rename'   => @title_writer,
                     'describe' => @title_describer}
  end

  def run(command, options)
    @tools[command].send(command, options)
  end
end
