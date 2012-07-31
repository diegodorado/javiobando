class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :orientation
      t.references :photoable, :polymorphic => true
      t.timestamps
    end
  end
end
