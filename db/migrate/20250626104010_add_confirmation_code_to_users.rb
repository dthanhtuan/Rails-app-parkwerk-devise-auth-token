class AddConfirmationCodeToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :confirmation_code, :string
    add_column :users, :confirmation_code_sent_at, :datetime
  end
end
