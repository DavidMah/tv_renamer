# Interface.rb
#
# Handles the message passing between the classes and the interfaces
# Messages get passed through the json protocol
#
# Send messages to receive_message
# The message must include the key
# "operation" : __operation name__
#
# Valid operation_names:
#   rename
#   scrape


require 'json'
load File.join(File.dirname(__FILE__), "wiki_scraper.rb")
load File.join(File.dirname(__FILE__), "title_writer.rb")

class Interface
  def initialize
    @wiki_scraper = WikiScraper.new
    @title_writer = TitleWriter.new
  end

  def receive_message(msg)
    begin
      message = JSON.parse(msg)
      operation = message["operation"]
      send(message["operation"], message)
    rescue
      puts "Invalid message passed.\n #{$!.backtrace}"
    end
  end

  # Mandatory: include a "titles" key that points to a pair of parallel lists.. current_names to target_names
  # Optional:  include a "directory" key that points to the directory that contains other given filenames
  def rename(message)
    titles    = message["titles"]
    data      = titles.first.zip(titles[1])
    directory = message["directory"]
    options   = {:data => data}
    options[:directory] = directory if directory

    @title_writer.write_names(options)
  end

  # Mandatory: include a "target" key that is the end pathname of the url for the wikipedia entry
  def scrape(message)
    url = message["target"]
    @wiki_scraper.retrieve_titles(url)
  end

  # Mandatory: include a "target" key that is the target pathname of the directory to retrieve names with
  def retrieve_names(message)
    target = message["target"]
    @title_writer.retrieve_current_names(target)
  end
end
