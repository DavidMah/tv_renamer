require 'wiki_scraper'
describe WikiScraper do
  before :each do
    @wiki_scraper = WikiScraper.new
  end
  describe "#scrape" do
    it "should call the helpers" do
      @wiki_scraper.should_receive(:extract_titles).once.with("garpley_url", {}).and_return([["39", "42"]])
      @wiki_scraper.should_receive(:write_titles).once.with([["39", "42"]], {}).and_return(0);
      @wiki_scraper.scrape("garpley_url", {})
    end
  end

  describe "#write_titles" do
    it "should send the data in json to standard output" do
      $stdout.should_receive(:print).once.with("garpley_data").and_return(nil)
      data = [["39", "42"]]
      data.should_receive(:to_json).once.and_return("garpley_data")
      @wiki_scraper.write_titles(data)
    end

    it "should send the data in yaml to standard output" do
      $stdout.should_receive(:print).once.with("garpley_data").and_return(nil)
      data = [["39", "42"]]
      data.should_receive(:to_yaml).once.and_return("garpley_data")
      @wiki_scraper.write_titles(data, {'format' => 'yaml'})
    end

    it "should send the data in yaml to standard output" do
      mock_file = mock('output')
      File.should_receive(:new).once.with("garpley_file", "w").and_return(mock_file)
      mock_file.should_receive(:print).once.with("garpley_data").and_return(nil)
      data = [["39", "42"]]
      data.should_receive(:to_json).once.and_return("garpley_data")
      @wiki_scraper.write_titles(data, {'output' => 'garpley_file'})
    end
  end
end
