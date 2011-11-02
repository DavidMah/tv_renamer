require 'json'
class TitleWriter

  def retrieve_current_names(directory)
    Dir.entries(directory)
  end

  def pair_names_and_titles(names, titles)
    names.zip(titles)
  end

  # Data is a list of pairs of filename to targetname
  def write_names(options = {})
    directory   = options[:directory]
    directory ||= "."
    data        = options[:data]

    log = File.new("log.txt", "w")

    data.each do |name_element|
      names = name_element.map{|e| File.join(directory, e)}
      log.syswrite "#{name_element.join(" : ")}\n"
      File.rename(*names)
    end

  end
end
