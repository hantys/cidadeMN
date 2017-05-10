class Category < ApplicationRecord
  mount_uploader :icon, PinUploader

  has_many :causes, :dependent => :destroy
  validates_presence_of :name, :icon
end
