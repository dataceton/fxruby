require 'fox16'
require 'pry'

include Fox

require './photo'
require './album'
require './album_view'

class PictureBook < FXMainWindow
  def initialize(app)
    super(app, "Picture Book", width: 600, height: 400)
    add_menu_bar
    @album = Album.new("My Photos")
    @album_view = AlbumView.new(self, @album)
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end

  def add_menu_bar
    menu_bar = FXMenuBar.new(self, LAYOUT_SIDE_TOP|LAYOUT_FILL_X)
    file_menu = FXMenuPane.new(self)
    file_menu.backColor = "white"
    FXMenuTitle.new(menu_bar, "File", popupMenu: file_menu)
    FXMenuCommand.new(file_menu, "Import...").connect(SEL_COMMAND, &method(:import_photos))
    FXMenuCommand.new(file_menu, "Exit").connect(SEL_COMMAND) { exit }
  end

  def import_photos(*args)
    dialog = FXFileDialog.new(self, "Import Photos")
    dialog.selectMode = SELECTFILE_MULTIPLE
    dialog.patternList = ["JPEG Images (*.jpg, *.jpeg)"]
    return if dialog.execute == 0
    dialog.filenames.each do |filename|
      photo = Photo.new(filename)
      @album.add_photo(photo)
      @album_view.add_photo(photo)
    end
    @album_view.create
  end
end

if __FILE__ == $0
  FXApp.new do |app|
    PictureBook.new(app)
    app.backColor = "white"
    app.create
    app.run
  end
end
