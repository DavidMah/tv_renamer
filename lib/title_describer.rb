require 'json'
require 'data_operations.rb'

class TitleDescriber
  include DataOperations

  def describe(options = {}, titles = nil)
    main_title = options['main_title'] || File.basename(Dir.getwd)
    script     = options['script']     || '#{main_title} - #{ep_num} - #{ep_title}'
    options['input'] = options['arguments'].first     if options['input'].nil?
    titles           = extract_data(options['input']) if titles.nil?
    names = describe_names(main_title, titles, script)
    write_name_file(names, options)
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

    zero_pad = digit_count(titles)
    new_titles.map!.with_index { |t, i| t.gsub(/\#{ep_num}/, "%0#{zero_pad}d" %(i + 1)) }

    new_titles
  end

  # Returns how many zeroes will need to be prepended to each title
  # because if there's ten titles, the first 9 will be 01, 02, 03...
  def digit_count(titles)
    Math.log10(titles.size).to_i + 1
  end

  def pair_names_and_titles(names, titles)
    names.zip(titles)
  end

  def write_name_file(names, options = {})
    directory   = options['directory']  || "."
    output_name = options['output'] || (options['input'] ? "name_file_#{options['input']}" : "name_file")
    files = retrieve_tv_files(directory)
    data  = files.zip(names).to_json

    name_file = find_filename(output_name)
    File.write(name_file, data)
  end

  def retrieve_tv_files(directory)
    Dir.entries(directory)
  end
end
