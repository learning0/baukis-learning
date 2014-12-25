class AlterAddress2 < ActiveRecord::Migration
  def change
    add_column :phones, :last_four_digits, :integer
    add_index :phones, :last_four_digits
  end
end
