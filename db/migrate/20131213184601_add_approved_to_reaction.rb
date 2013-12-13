class AddApprovedToReaction < ActiveRecord::Migration
  def change
    add_column :reactions, :approved, :boolean, default: false
    add_index :reactions, [:approved, :id]

    Reaction.all.each do |reaction|
      reaction.approved = true
      reaction.save
    end
  end
end
