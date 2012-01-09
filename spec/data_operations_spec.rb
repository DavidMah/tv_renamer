require 'data_operations'
class Obj
  include DataOperations
end

describe DataOperations do
  before :each do
    @obj = Obj.new
  end

  describe "#find_filename" do
    it "should return right away if name isn't taken" do
      File.should_receive(:exists?).once.with("39").and_return(false)
      @obj.find_filename("39").should == "39"
    end

    it "should count way upwards if names are taken" do
      File.should_receive(:exists?).twice.with("39").and_return(true)
      (1..3).each do |t|
        File.should_receive(:exists?).once.with("39_#{t}").and_return(true)
      end
      File.should_receive(:exists?).once.with("39_4").and_return(false)
      @obj.find_filename("39").should == "39_4"
    end
  end

  describe "#preserve_extensions" do
    it "should transfer the extension on the from to the to" do
      data = [['a.mkv', 'b'], ['c.mp4', 'd']]
      @obj.preserve_extensions(data).should == [['a.mkv', 'b.mkv'], ['c.mp4', 'd.mp4']]
    end
  end
end
