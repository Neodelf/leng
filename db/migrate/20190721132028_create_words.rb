class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.string :source
      t.string :translation
      t.string :target
      t.string :image_url

      t.timestamps
    end
  end
end
