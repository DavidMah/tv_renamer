Gem::Specification.new do |s|
  s.name        = 'tv_renamer'
  s.version     = '0.2.0'
  s.date        = '2011-12-11'
  s.summary     = 'tv_renamer scrapes tv show episode titles from wikipedia and helps users rename the files to be like the tv shows'
  s.description = 'tv_renamer scrapes tv show episode titles from wikipedia and helps users rename the files to be like the tv shows'
  s.authors     = ['David Mah']
  s.email       = 'Mahhaha@gmail.com'
  s.executables << 'tv_renamer'
  s.files       = ['lib/tv_renamer.rb',
                   'lib/tv_interface.rb',
                   'lib/data_operations.rb',
                   'lib/title_writer.rb',
                   'lib/title_describer.rb',
                   'lib/wiki_scraper.rb']
  s.add_runtime_dependency 'nokogiri', '~> 1.5.0'
end
