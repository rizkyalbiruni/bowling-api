class Frame < ApplicationRecord
  belongs_to :game
  has_many :throws
  validates :frame_nth, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
end
