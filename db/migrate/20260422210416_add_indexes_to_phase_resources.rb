class AddIndexesToPhaseResources < ActiveRecord::Migration[8.1]
  def change
    add_index :phase_resources, [:phase_id, :resource_id], unique: true, name: 'idx_phase_resource_unique'
  end
end
