class CreateThrows < ActiveRecord::Migration[7.1]
  def change
    create_table :throws do |t|
      t.integer :throw_nth
      t.integer :score
      t.references :frame, null: false, foreign_key: true

      t.timestamps
    end
  end
end
