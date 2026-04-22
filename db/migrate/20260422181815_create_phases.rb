class CreatePhases < ActiveRecord::Migration[8.1]
  def change
    create_table :phases do |t|
      t.string :name
      t.integer :position
      t.text :summary
      t.text :description

      t.timestamps
    end
  end
end
