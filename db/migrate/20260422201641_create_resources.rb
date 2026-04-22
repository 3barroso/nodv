class CreateResources < ActiveRecord::Migration[8.1]
  def change
    create_table :resources do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
