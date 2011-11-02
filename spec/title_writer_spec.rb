require 'rspec'
load File.join(File.dirname(__FILE__), "..", "lib", "title_writer.rb")

describe TitleWriter do
  before :each do
    @title_writer = TitleWriter.new
    @mock_log     = mock("log")
  end

  describe "write_names" do

    it "should set up a log file correctly" do
      File.should_receive(:new).once.with("log.txt", "w").and_return(@mock_log)
      @title_writer.write_names({:data => []})
    end

    it "should handle elements without a target directory correctly" do
      File.should_receive(:new).once.with("log.txt", "w").and_return(@mock_log)
      File.should_receive(:rename).once.with("./a", "./b").and_return(true)
      File.should_receive(:rename).once.with("./c", "./d").and_return(true)
      @mock_log.should_receive(:syswrite).once.with(%Q[a : b\n]).and_return(true)
      @mock_log.should_receive(:syswrite).once.with(%Q[c : d\n]).and_return(true)

      @title_writer.write_names({:data => [["a", "b"], ["c", "d"]]})
    end

    it "should handle elements with a target directory correctly" do
      File.should_receive(:new).once.with("log.txt", "w").and_return(@mock_log)
      File.should_receive(:rename).once.with("/home/garpley/a", "/home/garpley/b").and_return(true)
      File.should_receive(:rename).once.with("/home/garpley/c", "/home/garpley/d").and_return(true)
      @mock_log.should_receive(:syswrite).once.with(%Q[a : b\n]).and_return(true)
      @mock_log.should_receive(:syswrite).once.with(%Q[c : d\n]).and_return(true)

      @title_writer.write_names({:data => [["a", "b"], ["c", "d"]], :directory => "/home/garpley"})
    end
  end

end
