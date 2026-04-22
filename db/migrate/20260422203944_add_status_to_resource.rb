class AddStatusToResource < ActiveRecord::Migration[8.1]
  def change
    add_column :resources, :status, :integer, default: 0, null: false
    add_index :resources, :status
  end
end
