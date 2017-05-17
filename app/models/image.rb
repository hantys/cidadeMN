class Image < ApplicationRecord
  belongs_to :cause
  validates_presence_of :file
  mount_uploader :file, ImageUploader
end
