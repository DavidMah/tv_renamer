module DataOperations
  # Extracts JSON data from input file
  def extract_data(input)
    JSON.parse(File.read(input))
  end

  # Finds an unused filename based on the given name
  def find_filename(name)
    return name if not File.exists?(name)
    count = 1
    until not File.exists?("#{name}#{count}")
      count += 1
    end
    "#{name}#{count}"
  end
end
