# == Schema Information
#
# Table name: staff_events
#
#  id              :integer          not null, primary key
#  staff_member_id :integer          not null
#  type            :string(255)      not null
#  created_at      :datetime         not null
#

class StaffEvent < ActiveRecord::Base
  self.inheritance_column = nil
  
  belongs_to :member, class_name: 'StaffMember', foreign_key: 'staff_member_id'
  alias_attribute :occurred_at, :created_at
  
  DESCRIPTIONS = {
    logged_in: 'ログイン',
    logged_out: 'ログアウト',
    rejected: 'ログイン拒否'
  }
  
  def description
    DESCRIPTIONS[type.to_sym]
  end
end
