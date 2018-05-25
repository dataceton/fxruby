require './photo_view'

class AlbumView < FXScrollWindow
  
  attr_reader :album

  def initialize(p, album)
    super(p, opts: LAYOUT_FILL)
    self.backColor = FXRGB(248, 248, 255)
    @album = album
    FXMatrix.new(self, opts:  LAYOUT_FILL|MATRIX_BY_COLUMNS)
    @album.each_photo { |photo| add_photo(photo) }
  end

  def layout
    contentWindow.numColumns = [width/PhotoView::MAX_WIDTH, 1].max
    super
  end

  def add_photo(photo)
    PhotoView.new(contentWindow, photo)
  end
end