class CommandLineInterface
  def initialize
    loop {
      puts "[S]crape, [R]ename, [E]xit"
      choice = gets[0].upcase
      case choice
      when "S"; puts "Scraping"
      when "R"; puts "Renaming"
      when "E"; exit
      else
        puts "Nothing"
      end
    }
  end

  def scrape
    puts "What Wikipedia URL would you like to scrape?"
    url = gets.chomp
    puts "What is the full path of your log file target?"
    target = gets.chomp
    puts "scraping..."
  end

  def rename

  end
end
