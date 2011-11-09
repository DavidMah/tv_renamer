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

    begin
      log = File.new("log.txt", "w")

      data.each do |name_element|
        names = name_element.map{|e| File.join(directory, e)}
        log.syswrite "#{name_element.join(" : ")}\n"
        File.rename(*names)
      end
    rescue
      {:status => "failure: #{$!}"}
    end
      {:status => "success"}
  end

  # Create a title for every title/no using embedded symbols
  # Embeddable symbols to get substituted:
  # #{main_title} - Title of the TV Show
  # #{ep_title}   - Title of the Episode
  # #{ep_num}     - Number of the Episode
  def describe_names(titles, script, main_title)

    new_titles = Array.new(titles.size){ script }
    new_titles.map! { |t| t.gsub(/\#{main_title}/, main_title) }
    new_titles.map!.with_index { |t, i| t.gsub(/\#{ep_title}/, titles[i]) }

    zero_pad = Math.log10(titles.size).to_i + 1
    new_titles.map!.with_index { |t, i| t.gsub(/\#{ep_num}/, "%0#{zero_pad}d" %(i + 1)) }

    new_titles
  end

end
