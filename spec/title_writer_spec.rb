require 'rspec'
require 'title_writer'

describe TitleWriter do
  before :each do
    @title_writer = TitleWriter.new
    @mock_log     = mock("log")
  end

  describe "write_names" do
    before :each do
      @data      = [['from1', 'to1'], ['from2', 'to2']]
      @mock_file = mock('file')
      @title_writer.stub!(:find_filename).with('title_backup').and_return('title_backup')
      @options = {'data' => @data}

    end

    it "should produce a backup directory and make links for log=link" do
      @options['log'] = 'link'
      Dir.should_receive(:mkdir).once.with('title_backup').once.and_return(true)
      @data.each do |f, t|
        File.should_receive(:symlink).once.with(f, File.join("title_backup",t)).and_return(true)
        File.should_receive(:rename).once.with(f, t).and_return(true)
      end
      @title_writer.write_names(@options)
    end

    it "should produce a backup logfile and document the renames" do
      @options['log'] = 'file'
      File.should_receive(:open).once.with('title_backup', 'w').and_return(@mock_file)
      @mock_file.should_receive(:print).once.with('[["from1","to1"],["from2","to2"]]')
      @data.each do |f, t|
        File.should_receive(:rename).once.with(f, t).and_return(true)
      end
      @title_writer.write_names(@options)
    end
  end

  describe "describe_names" do
    it "should leave these unembeddy strings alone" do
      @title_writer.describe_names('miku', ['a', 'b', 'c'], 'garpley').should == ['garpley', 'garpley', 'garpley']
    end

    it "should slip in the main_title if needed" do
      @title_writer.describe_names('miku', ['a', 'b', 'c'], '#{main_title} garpley').should == ['miku garpley', 'miku garpley', 'miku garpley']
    end

    it "should slip in the ep_title if needed" do
      @title_writer.describe_names('miku', ['a', 'b', 'c'], '#{ep_title} garpley').should == ['a garpley', 'b garpley', 'c garpley']
    end

    it "should slip in the ep_num if needed" do
      @title_writer.describe_names('miku', ['a', 'b', 'c'], '#{ep_num} garpley').should == ['1 garpley', '2 garpley', '3 garpley']
    end

    it "should drop 0s in front of there are > 9 episodes" do
      result = @title_writer.describe_names('miku', ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'], '#{ep_num} garpley')
      result.should == ['01 garpley', '02 garpley', '03 garpley', '04 garpley', '05 garpley', '06 garpley', '07 garpley', '08 garpley', '09 garpley', '10 garpley']
    end

    it "should work with a combination of these substitutions" do
      result = @title_writer.describe_names('Adventure Time', ['a', 'b', 'c'], '#{main_title} - #{ep_num} - #{ep_title}.mkv')
      result.should == ['Adventure Time - 1 - a.mkv', 'Adventure Time - 2 - b.mkv', 'Adventure Time - 3 - c.mkv']
    end
  end

end
