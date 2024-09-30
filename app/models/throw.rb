class Throw < ApplicationRecord
  belongs_to :frame
  validates :throw_nth, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 3 }
end
