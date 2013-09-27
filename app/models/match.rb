# == Schema Information_
#
# Table name: matches
#
#  id         :integer          not null, primary key
#  white_id   :integer
#  black_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Match < ActiveRecord::Base
  has_many :moves

  def write_move(move)
    # write next move for match.
    # No fucking validation here!
    Move.create(:match_id => self.id, :move => move, :move_number => self.moves.count + 1)
  end
end
