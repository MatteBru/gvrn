class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.string :address
      t.string :city
      t.string :address_state
      t.string :zip_code
      t.string :password_digest
      t.integer :district_id

      t.timestamps
    end
  end
end
