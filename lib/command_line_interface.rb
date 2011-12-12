require 'interface'

class CommandLineInterface
  def initialize
    @interface = Interface.new
  end

  def scrape(url, logfile = nil)
    options = {'operation' => 'scrape',
               'target'    => url,
               'logfile'   => logfile}
    @interface.receive_message(options.to_json)
  end

end
