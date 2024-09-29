class CreateFrames < ActiveRecord::Migration[7.1]
  def change
    create_table :frames do |t|
      t.integer :frame_nth
      t.boolean :is_strike
      t.boolean :is_spare
      t.integer :total_score
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
