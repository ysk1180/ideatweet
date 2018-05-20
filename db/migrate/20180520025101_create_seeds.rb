class CreateSeeds < ActiveRecord::Migration[5.2]
  def change
    create_table :seeds do |t|
      t.string :content

      t.timestamps
    end
  end
end
