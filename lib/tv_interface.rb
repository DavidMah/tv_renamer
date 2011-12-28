class TvInterface
  def initialize
    @interface = Interface.new
    @wiki_scraper = WikiScraper.new
    @title_writer = TitleWriter.new
    @tools        = {'scrape'   => @wiki_scraper,
                     'rename'   => @title_writer,
                     'describe' => @title_writer}
  end

  def run(command, arguments)
    @tools.send(command, *arguments)
  end
end
