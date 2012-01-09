require 'json'
class TitleWriter

  def rename(*arguments)
    write_names(*arguments)
  end

  def describe(*arguments)
    describe_names(*arguments)
  end



  def retrieve_current_names(directory)
    Dir.entries(directory)
  end

  def pair_names_and_titles(names, titles)
    names.zip(titles)
  end

  # Data is a list of pairs of filename to targetname
  #   Will be explicitly passed in if this call to tv_renamer also did scraping
  #   Otherwise, input will be the name of the file that include renaming data in the same structure(but in json)
  # log can be link -- make a directory of links
  def write_names(options = {}, data = nil)
    data        = extract_data(options['input']) if data.nil?
    log         = options['log']    || 'link'
    output_name = options['output'] || 'title_backup'

    if log == 'link'
      backup_dir = find_filename(output_name)
      Dir.mkdir(backup_dir)
      data.each do |from, to|
        File.symlink(from, File.join(backup_dir, to))
      end
    elsif log == 'file' or link != "none"
      backup_file = find_filename(output_name)
      output = File.open(backup_file, 'w')
      output.print(data.to_json)
    elsif log == "none"
      puts "excluding backup"
    end

    data.each do |from, to|
      File.rename(from, to)
    end
  end

  # Extracts JSON data from input file
  def extract_data(input)
    JSON.parse(File.read(input))
  end

  def find_filename(name)
    return name if not File.exists?(name)
    count = 1
    until not File.exists?("#{name}#{count}")
      count += 1
    end
    "#{name}#{count}"
  end

  def describe(options = {}, titles = nil)
    main_title = options['main_title']
    script     = options['script']
    titles     = extract_data(options['input']) if titles.nil?
    describe_names(main_title, titles, script)
  end

  # Create a title for every title/no using embedded symbols
  # Embeddable symbols to get substituted:
  # #{main_title} - Title of the TV Show
  # #{ep_title}   - Title of the Episode
  # #{ep_num}     - Number of the Episode
  def describe_names(main_title, titles, script)

    new_titles = Array.new(titles.size){ script }
    new_titles.map! { |t| t.gsub(/\#{main_title}/, main_title) }
    new_titles.map!.with_index { |t, i| t.gsub(/\#{ep_title}/, titles[i]) }

    zero_pad = Math.log10(titles.size).to_i + 1
    new_titles.map!.with_index { |t, i| t.gsub(/\#{ep_num}/, "%0#{zero_pad}d" %(i + 1)) }

    new_titles
  end

end
