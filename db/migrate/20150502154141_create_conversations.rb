class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :u1_id
      t.integer :u2_id
      t.string :u1_pk
      t.string :u2_pk
      t.string :channel_name

      t.timestamps null: false
    end
  end
end
