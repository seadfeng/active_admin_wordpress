class AdminUser < ApplicationRecord
  role_based_authorizable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable
  
         
  def full_name
      "#{first_name} #{last_name}"
  end

  def display_name
    full_name
  end 
end
