# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  msg        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Post < ApplicationRecord

  belongs_to :user

  has_many :match_posts ,foreign_key: :post_id , class_name:"Like"
  has_many :likes , through: :match_posts , source: :user 





  def check_session(session_data)

    if(session_data != self.user_id)
      errors.add(:user_id,"You cann't create other people's post.")
      return false
    end
    return true
  end

  def addErrorUpdate
    errors.add(:user_id,"You cant edit other people's user_id")
    return false
  end

end
