class AddTagToArticles < ActiveRecord::Migration[7.2]
  def change
    add_column :articles, :tags, :string
  end
end
