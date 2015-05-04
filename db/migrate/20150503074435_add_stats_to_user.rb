class AddStatsToUser < ActiveRecord::Migration
  def change
    add_column :users, :status, :string, :default => "Hey there I'm using whisper"
  end
end
