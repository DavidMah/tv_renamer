require 'interface'
describe Interface do
  before :each do
    @wiki_scraper_mock = mock('wiki_scraper')
    @title_writer_mock = mock('title_writer')
    WikiScraper.stub!(:new).and_return(@wiki_scraper_mock)
    TitleWriter.stub!(:new).and_return(@title_writer_mock)
    @interface = Interface.new
  end

  describe "#receive_message" do
    it "should read the operation key and run that function" do
      @interface.should_receive("garpley").once.with({"operation" => "garpley"}).and_return(true)
      @interface.receive_message(%Q[{"operation" : "garpley"}])
    end
  end

  describe "#rename" do
    it "should pass the titles without the not existing directory" do
      @title_writer_mock.should_receive(:write_names).once.with({:data => [["1", "3"], ["2", "4"]]})
      @interface.rename({"titles" => [["1", "2"], ["3", "4"]]})
    end

    it "should pass the titles with the existing directory" do
      @title_writer_mock.should_receive(:write_names).once.with({:data => [["1", "3"], ["2", "4"]], :directory => "garpley"})
      @interface.rename({"titles" => [["1", "2"], ["3", "4"]], "directory" => "garpley"})
    end
  end

  describe "#scrape" do
    it "should send the url in" do
      @wiki_scraper_mock.should_receive(:retrieve_titles).once.with("garpley", nil)
      @interface.scrape({"target" => "garpley"})
    end
  end

  describe "#current_names" do
    it "should send the directory in" do
      @title_writer_mock.should_receive(:retrieve_current_names).once.with("/garpley/bargenly")
      @interface.retrieve_names({"target" => "/garpley/bargenly"})
    end
  end
end
