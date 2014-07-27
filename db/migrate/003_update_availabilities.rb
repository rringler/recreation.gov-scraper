class UpdateAvailabilities < ActiveRecord::Migration
  def self.up
    add_column :availabilities, :url, :string
  end

  def self.down
    remove_column :availabilities, :url
  end
end
