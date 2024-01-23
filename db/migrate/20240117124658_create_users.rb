class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.jsonb :name
      t.integer :age
      t.string :gender
      t.string :uuid
      t.jsonb :location

      t.timestamps
    end
  end
end
