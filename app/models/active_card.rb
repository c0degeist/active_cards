class ActiveCard < ApplicationRecord

  has_defaults level: 0

  validates :question, :answer, :level, presence: true

  belongs_to :deck

  scope :ordered, -> { order(created_at: :desc) }

end
