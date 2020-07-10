class CreateBlogs < ActiveRecord::Migration[6.0]
  def up
    create_table :blogs do |t|
      t.belongs_to :admin_user 
      t.string :url, null: false, default: ""
      t.string :name
      t.string :user
      t.string :password
      t.string :description  
      t.string :status 
      t.datetime   :deleted_at
      t.timestamps
      t.index ["url"], name: "index_blogs_on_url", unique: true
    end
  end

  def down
    drop_table :blogs
  end
end
