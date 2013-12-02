class CreateReactions < ActiveRecord::Migration
  def change
    create_table :reactions do |t|
      t.references :user, index: true
      t.string :title
      t.string :image

      t.timestamps
    end
  end
end
