require 'command_line_interface'
require 'optparse'

interface = CommandLineInterface.new
options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: tv_renamer <command> options"

  opts.on('-h', '--help', 'Display This Screen') do
    puts opts.banner
    exit
  end

  opts.on('-s', '--scrape', 'Scrape') do
    interface.scrape(ARGV[0])
  end
end

optparse.parse!
