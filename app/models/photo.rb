class Photo < ActiveRecord::Base
  belongs_to :photoable, :polymorphic => true

  validates :image, :presence => true  
  validates :orientation, :presence => true  

  delegate :url, :to => :image

  has_attached_file :image, {
      :styles => { 
        :original => "900x", 
        :portrait => "900x600#", 
        :landscape => "600x900#", 
        :movieframe => "600x400#", 
        :thumb => "100x100#" }
    }


  def orientation_enum
    [['portrait', :pt],['landscape', :ls]]
  end

end
