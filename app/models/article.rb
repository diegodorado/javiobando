class Article < ActiveRecord::Base
  has_many :photos, :as => :photoable, :dependent => :destroy

  validates :section, :presence => true  
  validates :view_as, :presence => true  

  accepts_nested_attributes_for :photos, :allow_destroy => true

  #scope :for_year, lambda {|year| where("published_at >= ? and published_at <= ?", "#{year}-01-01", "#{year}-12-31")}

  def section_enum
    [['Personal', :pe],['Comercial', :co],['Portada', :po]]
  end

  def view_as_enum
    [['Slideshow', :ss],['Full Screen', :fs],['Movie Frames', :mf]]
  end
  
end
