class ActiveCard < ApplicationRecord

  MIN_LEVEL = 0
  MAX_LEVEL = 8

  BREAKTIME_BY_LEVEL = {
    0 => 0.days,
    1 => 1.day,
    2 => 2.days,
    3 => 3.days,
    4 => 6.days,
    5 => 12.days,
    6 => 24.days,
    7 => 48.days,
    8 => 90.days
  }

  has_defaults level: 0

  validates :question, :answer, :level, :next_recall, presence: true

  belongs_to :deck

  before_validation :set_next_recall

  scope :ordered, -> { order(created_at: :desc) }
  scope :pending, -> { where("DATE(next_recall) <= ?", Date.today) }

  def level_up!
    unless max_level?
      self.level += 1
      save!
    end
  end

  def reset_level!
    unless min_level?
      self.level == MIN_LEVEL
      save!
    end
  end

  def max_level?
    level >= MAX_LEVEL
  end

  def min_level?
    level <= MIN_LEVEL
  end

  def pending?
    next_recall <= Date.today
  end

  private

  def set_next_recall
    self.next_recall = if last_recal.present?
      last_recal + BREAKTIME_BY_LEVEL[level]
    else
      DateTime.now
    end
  end

end
