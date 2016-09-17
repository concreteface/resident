class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :title, null: false
      t.string :artist, null: false
      t.string :label_name
      t.string :review_link
      t.string :cover_url
      t.integer :rating
      t.string :review
    end
  end
end
