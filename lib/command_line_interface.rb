require 'interface'

class CommandLineInterface
  def initialize
    @interface = Interface.new
  end

  def scrape(url)
    options = {'operation' => 'scrape', 'target' => url}
    result = @interface.receive_message(options.to_json)
    pretty_print result
  end


  def pretty_print(titles)
    titles.each do |t|
      puts t.join(" - ")
    end
  end
end
