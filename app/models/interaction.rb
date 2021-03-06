class Interaction < ActiveRecord::Base
  belongs_to :user_one, class_name: 'User'
  belongs_to :user_two, class_name: 'User'

  validates :user_one_id, uniqueness: {scope: :user_two_id, message: "cant interact twice with the same user"}
  validate :cant_interact_myself
  before_save :check_match

  def cant_interact_myself
    if self.user_one.id == self.user_two.id
      errors.add(:expiration_date, "can't interact with myself")
    end
  end
  def match
    i = Match.where(user_one_id: self.user_one.id, user_two_id: self.user_two.id)
    i.first
  end
  def check_match
    i = Interaction.where(user_one: self.user_two, user_two:self.user_one)
    unless i.empty?
      if i.first.like && self.like
        self.matched = true
        Match.create(user_one_id: self.user_one.id, user_two_id: self.user_two.id)
      end
    end
  end
end
