require 'title_describer'

describe TitleDescriber do
  before :each do 
    @title_describer = TitleDescriber.new
  end
  describe "describe_names" do
    it "should leave these unembeddy strings alone" do
      @title_describer.describe_names('miku', ['a', 'b', 'c'], 'garpley').should == ['garpley', 'garpley', 'garpley']
    end

    it "should slip in the main_title if needed" do
      @title_describer.describe_names('miku', ['a', 'b', 'c'], '#{main_title} garpley').should == ['miku garpley', 'miku garpley', 'miku garpley']
    end

    it "should slip in the ep_title if needed" do
      @title_describer.describe_names('miku', ['a', 'b', 'c'], '#{ep_title} garpley').should == ['a garpley', 'b garpley', 'c garpley']
    end

    it "should slip in the ep_num if needed" do
      @title_describer.describe_names('miku', ['a', 'b', 'c'], '#{ep_num} garpley').should == ['1 garpley', '2 garpley', '3 garpley']
    end

    it "should drop 0s in front of there are > 9 episodes" do
      result = @title_describer.describe_names('miku', ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'], '#{ep_num} garpley')
      result.should == ['01 garpley', '02 garpley', '03 garpley', '04 garpley', '05 garpley', '06 garpley', '07 garpley', '08 garpley', '09 garpley', '10 garpley']
    end

    it "should work with a combination of these substitutions" do
      result = @title_describer.describe_names('Adventure Time', ['a', 'b', 'c'], '#{main_title} - #{ep_num} - #{ep_title}.mkv')
      result.should == ['Adventure Time - 1 - a.mkv', 'Adventure Time - 2 - b.mkv', 'Adventure Time - 3 - c.mkv']
    end
  end
end
