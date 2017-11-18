class CreateAppointments < ActiveRecord::Migration[5.1]
  def change
    create_table :appointments do |t|
      t.references :congressperson, polymorphic: true, index: {name: 'index_appointments_on_congressperson'}
      t.integer :user_id
      t.datetime :time

      t.timestamps
    end
  end
end
