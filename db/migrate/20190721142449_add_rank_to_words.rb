class AddRankToWords < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :rank, :integer
  end
end
