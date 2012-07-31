class RenameTypeFromArticles < ActiveRecord::Migration
  def change

    change_table :articles do |t|
      t.rename :type, :view_as
    end

  end
end
