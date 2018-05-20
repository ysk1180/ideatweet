class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :picture
      t.integer :seed1_id
      t.integer :seed2_id

      t.timestamps
    end
  end
end
