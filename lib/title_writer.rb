class TitleWriter
  def retrieve_current_names(directory)
    Dir.entries(directory)
  end
end
