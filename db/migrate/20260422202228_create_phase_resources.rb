class CreatePhaseResources < ActiveRecord::Migration[8.1]
  def change
    create_table :phase_resources do |t|
      t.references :phase, null: false, foreign_key: true
      t.references :resource, null: false, foreign_key: true

      t.timestamps
    end
  end
end
