class FrameSerializer < ActiveModel::Serializer
  attributes :id, :frame_nth, :is_strike, :is_spare, :total_score

  has_many :throws
end
