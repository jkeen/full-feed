class CreateFullFeeds < ActiveRecord::Migration
  def self.up
    create_table :full_feeds do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :full_feeds
  end
end
