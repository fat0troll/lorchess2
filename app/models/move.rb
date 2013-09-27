# == Schema Information
#
# Table name: moves
#
#  id          :integer          not null, primary key
#  match_id    :integer
#  move_number :integer
#  move        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Move < ActiveRecord::Base
  belongs_to :match

  validates :move, :move_number, :match_id, :presence => true
end
