require 'gtk2'

window = Gtk::Window.new("Wiki Episode Scraper")
window.resize(800, 600)
window.signal_connect("delete_event") { Gtk.main_quit; false }
window.border_width = 10

full_wrapper = Gtk::VBox.new(false, 0)

# Upper Buttons
actions = Gtk::HBox.new(false, 0)
rename  = Gtk::Button.new("Rename")
rename.signal_connect("clicked") { puts "renaming" }

describer = Gtk::Entry.new
actions.pack_start(rename, true, false, 0)
actions.pack_end(describer, true, false, 0)

# Lower title dialog
lists  = Gtk::HBox.new(true, 15)
titles = Gtk::TextView.new
titles.buffer.text = "default\ndefault\ndefault"

targets = Gtk::TextView.new
targets.buffer.text = "example"

lists.pack_start(Gtk::VSeparator.new)
lists.pack_start(targets)
lists.pack_start(Gtk::VSeparator.new)
lists.pack_start(titles)
lists.pack_start(Gtk::VSeparator.new)

full_wrapper.pack_start(actions, true, false, 0)
full_wrapper.pack_end(lists, true, false, 0)


window.add(full_wrapper)
window.show_all
Gtk.main
