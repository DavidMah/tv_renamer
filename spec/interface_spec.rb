require 'rspec'
load File.join(File.dirname(__FILE__), "..", "lib", "interface.rb")

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
      @title_writer_mock.should_receive(:write_names).once.with({:data => {"a" => "b", "c" => "d"}})
      @interface.rename({"titles" => {"a" => "b", "c" => "d"}})
    end

    it "should pass the titles with the existing directory" do
      @title_writer_mock.should_receive(:write_names).once.with({:data => {"a" => "b", "c" => "d"}, :directory => "garpley"})
      @interface.rename({"titles" => {"a" => "b", "c" => "d"}, "directory" => "garpley"})
    end
  end

  describe "#scrape" do
    it "should send the url in" do
      @wiki_scraper_mock.should_receive(:retrieve_titles).once.with("garpley")
      @interface.scrape({"target" => "garpley"})
    end
  end
end
