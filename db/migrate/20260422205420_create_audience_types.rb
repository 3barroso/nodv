class CreateAudienceTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :audience_types do |t|
      t.string :name

      t.timestamps
    end
    add_index :audience_types, :name, unique: true
  end
end
