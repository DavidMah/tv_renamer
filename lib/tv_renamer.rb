require 'tv_interface'
require 'optparse'

interface = TvInterface.new
options = {}

opts_banner = ""
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: tv_renamer <command> <arguments> options"
  opts_banner = opts.banner

  opts.on('-h', '--help', 'Display This Screen') do
    puts opts.banner
    puts "commands:"
    puts "  scrape   \"<url>\"-- Retrieve title names from Wikipedia"
    puts "  describe \"scrape_filename\"-- Build write file from scrape output"
    puts "  write    -- Rename files in a directory"
    puts "  rename   -- Combines the three tasks"
    exit
  end

  opts.on('-i', '--input FILE', 'file input for command') do |file|
    options['input'] = file
  end

  # Log Types: [link|file|none]
  opts.on('-l', '--log TYPE', 'backup output for write') do |type|
    options['log'] = type
  end

  opts.on('-o', '--output FILE', 'output to FILE') do |file|
    options['output'] = file
  end

  opts.on('-f', '--format [json|yaml]', 'data format for any output') do |format|
    options['format'] = format
  end

  opts.on('--main_title SHOW_TITLE', 'name of show title for descriptions') do |title|
    options['main_title'] = title
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
  options['arguments'] = ARGV

  interface = TvInterface.new
  interface.run(command, options)
rescue => ex
  if options['trace']
    puts "#{ex.inspect}"
    puts "#{ex.backtrace}"
  else
    puts "There was an error! Add the --trace switch for the stack trace"
  end
  puts opts_banner
  exit
end
