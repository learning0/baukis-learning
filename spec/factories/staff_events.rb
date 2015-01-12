# == Schema Information
#
# Table name: staff_events
#
#  id              :integer          not null, primary key
#  staff_member_id :integer          not null
#  type            :string(255)      not null
#  created_at      :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
end
