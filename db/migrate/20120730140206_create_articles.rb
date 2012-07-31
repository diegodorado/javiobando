class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :section
      t.string :type

      t.timestamps
    end
  end
end
