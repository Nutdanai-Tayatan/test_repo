# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string
#  name            :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  has_many :posts
  has_many :follows
  has_secure_password

  def check_email
    if(User.find_by_email(self.email))
      errors.add(:email, "already exists")
      false
    end
    true
  end

  def check_password(password_confirmation)

    if(password_confirmation != self.password)
      errors.add(:password,"do not match with password_confirmation")
      return false
    end
    return true

  end

  def login
    @user = User.find_by_email(self.email)
    if(@user)
      if(@user.authenticate(self.password))
        self.id = @user.id
        return true
      else
        errors.add(:password,"incorrect !!!")
        false
      end
    else
      errors.add(:email,"incorrect !!!")
      false
    end
  end



end
