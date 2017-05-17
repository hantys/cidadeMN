class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :causes, :dependent => :destroy
  validates_uniqueness_of :email
  def image_link
    return "user.png"
  end
end
