require 'title_writer'

describe TitleWriter do
  before :each do
    @title_writer = TitleWriter.new
    @mock_log     = mock("log")
  end

  describe "write_names" do
    before :each do
      @raw_data   = [['from1.mkv', 'to1'], ['from2.mp4', 'to2']]
      @clean_data = [['from1.mkv', 'to1.mkv'], ['from2.mp4', 'to2.mp4']]
      @mock_file  = mock('file')
      @title_writer.stub!(:find_filename).with('title_backup').and_return('title_backup')
      @title_writer.should_receive(:extract_data).once.and_return(@raw_data)
      @title_writer.should_receive(:preserve_extensions).once.with(@raw_data).and_return(@clean_data)
      @options = {}
    end

    it "should produce a backup directory and make links for log=link" do
      @options['log'] = 'link'
      Dir.should_receive(:mkdir).once.with('title_backup').once.and_return(true)
      @clean_data.each do |f, t|
        File.should_receive(:symlink).once.with(f, File.join("title_backup",t)).and_return(true)
        File.should_receive(:rename).once.with(f, t).and_return(true)
      end
      @title_writer.write_names(@options)
    end

    it "should produce a backup logfile and document the renames" do
      @options['log'] = 'file'
      File.should_receive(:write).once.with('title_backup', '[["from1.mkv","to1.mkv"],["from2.mp4","to2.mp4"]]').and_return(true)
      @clean_data.each do |f, t|
        File.should_receive(:rename).once.with(f, t).and_return(true)
      end
      @title_writer.write_names(@options)
    end
  end

end
