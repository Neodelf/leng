class AddClientIdToWords < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :client_id, :string
  end
end
