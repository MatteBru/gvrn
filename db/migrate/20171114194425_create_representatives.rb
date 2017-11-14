class CreateRepresentatives < ActiveRecord::Migration[5.1]
  def change
    create_table :representatives do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :image
      t.date :date_of_birth
      t.text :biography
      t.string :party
      t.date :start_date
      t.string :leadership_role
      t.string :twitter_account
      t.string :facebook_account
      t.string :youtube_account
      t.string :url
      t.string :contact_form
      t.boolean :in_office
      t.float :dw_nominate
      t.string :next_election
      t.integer :total_votes
      t.integer :missed_votes
      t.string :office
      t.string :phone
      t.string :votes_with_party_pct
      t.string :gender
      t.boolean :at_large
      t.string :google_entity_id
      t.string :wikipedia
      t.integer :district_id

      t.timestamps
    end
  end
end
