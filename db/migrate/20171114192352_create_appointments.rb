class CreateAppointments < ActiveRecord::Migration[5.1]
  def change
    create_table :appointments do |t|
      t.integer :representative_id
      t.integer :user_id
      t.datetime :time

      t.timestamps
    end
  end
end
