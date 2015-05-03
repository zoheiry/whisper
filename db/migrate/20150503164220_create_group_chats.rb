class CreateGroupChats < ActiveRecord::Migration
  def change
    create_table :group_chats do |t|
      t.integer :u_id
      t.integer :group_id
      t.string	:group_name

      t.timestamps null: false
    end
  end
end
