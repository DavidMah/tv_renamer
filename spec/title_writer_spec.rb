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

  describe "describe_names" do
    it "should leave these unembeddy strings alone" do
      @title_writer.describe_names(['a', 'b', 'c'], 'garpley', 'miku').should == ['garpley', 'garpley', 'garpley']
    end

    it "should slip in the main_title if needed" do
      @title_writer.describe_names(['a', 'b', 'c'], '#{main_title} garpley', 'miku').should == ['miku garpley', 'miku garpley', 'miku garpley']
    end

    it "should slip in the ep_title if needed" do
      @title_writer.describe_names(['a', 'b', 'c'], '#{ep_title} garpley', 'miku').should == ['a garpley', 'b garpley', 'c garpley']
    end

    it "should slip in the ep_num if needed" do
      @title_writer.describe_names(['a', 'b', 'c'], '#{ep_num} garpley', 'miku').should == ['1 garpley', '2 garpley', '3 garpley']
    end

    it "should drop 0s in front of there are > 9 episodes" do
      result = @title_writer.describe_names(['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'], '#{ep_num} garpley', 'miku')
      result.should == ['01 garpley', '02 garpley', '03 garpley', '04 garpley', '05 garpley', '06 garpley', '07 garpley', '08 garpley', '09 garpley', '10 garpley']
    end

    it "should work with a combination of these substitutions" do
      result = @title_writer.describe_names(['a', 'b', 'c'], '#{main_title} - #{ep_num} - #{ep_title}.mkv', 'Adventure Time')
      result.should == ['Adventure Time - 1 - a.mkv', 'Adventure Time - 2 - b.mkv', 'Adventure Time - 3 - c.mkv']
    end
  end

end
