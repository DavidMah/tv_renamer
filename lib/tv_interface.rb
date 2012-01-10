class TvInterface
  def initialize
    @wiki_scraper   = WikiScraper.new
    @title_writer   = TitleWriter.new
    @title_describr = TitleDescriber.new
    @tools        = {'scrape'   => @wiki_scraper,
                     'rename'   => @title_writer,
                     'describe' => @title_describer}
  end

  def run(command, arguments)
    @tools.send(command, *arguments)
  end
end
