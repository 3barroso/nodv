class CreateResourceAudienceTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :resource_audience_types do |t|
      t.references :resource, null: false, foreign_key: true
      t.references :audience_type, null: false, foreign_key: true

      t.timestamps
    end

    add_index :resource_audience_types, [:resource_id, :audience_type_id], unique: true, name: 'idx_resource_audience_unique'
  end
end
