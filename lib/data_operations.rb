module DataOperations
  # Extracts JSON data from input file
  def extract_data(input)
    JSON.parse(File.read(input))
  end

  # Finds an unused filename based on the given name
  def find_filename(name)
    return name if not File.exists?(name)

    new_name = name
    count = 0
    until not File.exists?(new_name)
      count += 1
      new_name = "#{name}_#{count}"
    end

    new_name
  end

  # Data is an array of pairs which represent files to be renamed(from => to)
  # Take the file extensions on the from, and slap them onto the tos
  def preserve_extensions(data)
    data.map do |from, to|
      [from, "#{to}#{File.extname(from)}"]
    end
  end
end
