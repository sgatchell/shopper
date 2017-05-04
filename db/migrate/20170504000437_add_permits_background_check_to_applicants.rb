class AddPermitsBackgroundCheckToApplicants < ActiveRecord::Migration[5.0]
  def change
    add_column :applicants, :permits_background_check, :boolean, default: false, null: false
  end
end
