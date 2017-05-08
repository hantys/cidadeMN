class CreateCauses < ActiveRecord::Migration[5.1]
  def change
    create_table :causes do |t|
      t.integer :user_id
      t.text :text
      t.float :latitude
      t.float :longitude
      t.integer :cateory_id
      t.boolean :support
      t.integer :status
      t.date :start_date
      t.date :end_date
      t.string :address

      t.timestamps
    end
  end
end
