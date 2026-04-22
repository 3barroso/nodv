class AddSelfJoinToPhases < ActiveRecord::Migration[8.1]
  def change
    add_reference :phases, :parent, foreign_key: { to_table: :phases }, null: true
  end
end
