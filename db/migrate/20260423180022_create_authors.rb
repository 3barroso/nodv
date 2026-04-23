class CreateAuthors < ActiveRecord::Migration[8.1]
  def change
    create_table :authors do |t|
      t.string :pen_name
      t.text :information
      t.boolean :primary, default: false, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_reference :resources, :author, foreign_key: true, index: true
  end
end
