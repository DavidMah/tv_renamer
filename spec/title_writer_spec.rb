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
      @title_writer.should_receive(:extract_data).once.and_return(@data)

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
      File.should_receive(:write).once.with('title_backup', '[["from1","to1"],["from2","to2"]]').and_return(true)
      @data.each do |f, t|
        File.should_receive(:rename).once.with(f, t).and_return(true)
      end
      @title_writer.write_names(@options)
    end
  end

  describe "#extract_data" do
    it 'should turn crap into json' do
      File.should_receive(:read).once.with('garpley').and_return('[["from1","to1"],["from2","to2"]]')
      @title_writer.extract_data('garpley').should == [['from1', 'to1'], ['from2', 'to2']]
    end
  end


end
