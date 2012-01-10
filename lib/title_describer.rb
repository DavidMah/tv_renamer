require 'json'
class TitleDescriber

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

  def pair_names_and_titles(names, titles)
    names.zip(titles)
  end

  # Extracts JSON data from input file
  def extract_data(input)
    JSON.parse(File.read(input))
  end
end
