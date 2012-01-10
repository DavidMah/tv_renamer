require 'command_line_interface'
require 'optparse'

interface = CommandLineInterface.new
options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: tv_renamer <command> <arguments> options"

  opts.on('-h', '--help', 'Display This Screen') do
    puts opts.banner
    puts "commands:"
    puts "  scrape   -- Retrieve title names from Wikipedia"
    puts "  describe \"<script>\" -- Build write file from scrape output"
    puts "  write    -- Rename files in a directory"
    puts "  rename   -- Combines the three tasks"
    exit
  end

  opts.on('-i', '--input FILE', 'write file input') do |file|
    options['input'] = file
  end

  opts.on('-l', '--log TYPE', 'backup output for write') do |type|
    options['log'] = type
  end

  opts.on('-o', '--output FILE', 'output to FILE') do |file|
    options['output'] = file
  end

  opts.on('-f', '--format [json|yaml]', 'data format for any output') do |format|
    options['format'] = format
  end

  opts.on('--trace', 'Print stack trace to standard output') do
    options['trace'] = true
  end
end

begin
  optparse.parse!
  help_message if ARGV.empty?

  # parse command out from the arguments
  command   = ARGV.shift
  arguments = ARGV << options

  interface = TvInterface.new
  interface.run(command, arguments)
rescue => ex
  if options['trace']
    puts "#{ex.inspect}"
  else
    puts "There was an error! Add the --trace switch for the stack trace"
  end
  puts opts_banner
  exit
end
