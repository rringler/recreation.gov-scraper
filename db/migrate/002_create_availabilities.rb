class CreateAvailabilities < ActiveRecord::Migration
  def self.up
    create_table :availabilities do |t|
      ## Foreign keys
      t.integer  :query_id, null: false

      t.string   :site
      t.string   :date
      t.timestamps
    end
  end

  def self.down
    drop_table :availabilities
  end
end
