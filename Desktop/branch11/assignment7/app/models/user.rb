# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string
#  name            :string
#  password_digest :string
#
class User < ApplicationRecord
  has_many :posts
  has_many :likes

  has_many :match_followees ,foreign_key: :followee_id , class_name:"Follow"
  has_many :followings ,through: :match_followees

  has_many :match_followers, foreign_key: :following_id , class_name:"Follow"
  has_many :followees , through: :match_followers








  has_secure_password

  def check_email
    if(User.find_by_email(self.email))
      errors.add(:email, "already exists")
      return false
    end
    return true
  end

  def check_name
    if(User.find_by_name(self.name))
      errors.add(:name, "already exists")
      return false
    end
    return true
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

  def get_feed_post
    query = <<-SQL
    SELECT p.user_id as name , p.msg as msg , p.updated_at as update_at ,p.id as postID
    FROM users u,follows f ,posts p
    WHERE f.followee_id = "#{self.id}" and p.user_id = f.following_id and u.id = "#{self.id}"
    order by update_at desc
    SQL

    result = ActiveRecord::Base.connection.execute(query)
    return result
  end

  def getProfile
    query = <<-SQL
    SELECT u.name as name ,p.msg as msg , p.updated_at as update_at,p.id as postID
    FROM users u , posts p
    WHERE p.user_id = "#{self.id}" and u.id = "#{self.id}"
    order by update_at DESC
    SQL
    result = ActiveRecord::Base.connection.execute(query)
    return result
  end







end
