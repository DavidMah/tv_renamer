class TitleWriter
  def retrieve_current_names(directory)
    Dir.entries(directory)
  end
  # Data is a list of pairs of filename to targetname
  def write_names(directory = ".", data)
    log = File.new("log.txt", "w")
    data.each do |name_element|
      names = name_element.map{|e| File.join(directory, e)}
      log.syswrite "#{name_element.join(" --> ")}\n"
      File.rename(*names)
    end
  end
end
