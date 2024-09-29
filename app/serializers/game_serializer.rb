class GameSerializer < ActiveModel::Serializer
  attributes :id, :total_score, :current_frame

  has_many :frames
end
