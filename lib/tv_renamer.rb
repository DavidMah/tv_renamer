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

  opts.on('-l', '--log FILE', 'log output to FILE') do |file|
    options[:logfile] = file
  end
end

optparse.parse!

command   = ARGV.shift
arguments = ARGV
interface.send(command, *arguments)
