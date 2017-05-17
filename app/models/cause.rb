class Cause < ApplicationRecord
  validates_presence_of :text, :category_id, :latitude, :longitude, :user_id

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode  # auto-fetch address

  belongs_to :user
  belongs_to :category
  has_many :images, :dependent => :destroy
  accepts_nested_attributes_for :images, :allow_destroy => true

  default_scope -> {order('id desc')}

  def self.find_closest(latitude, longitude, categoria, limit)
    if categoria == '0'
      query = <<-SQL
        SELECT *, (3959 * ACOS(COS(RADIANS(?)) * COS(RADIANS(latitude)) * COS(RADIANS(longitude) - RADIANS(?)) + SIN(RADIANS(?)) * SIN(RADIANS(latitude)))) AS distance
        FROM causes
        ORDER BY distance
        LIMIT ?
        SQL
      find_by_sql([query, latitude.to_f, longitude.to_f, latitude.to_f, limit.to_i])
    else
      query = <<-SQL
        SELECT *, (3959 * ACOS(COS(RADIANS(?)) * COS(RADIANS(latitude)) * COS(RADIANS(longitude) - RADIANS(?)) + SIN(RADIANS(?)) * SIN(RADIANS(latitude)))) AS distance
        FROM causes WHERE category_id = ?
        ORDER BY distance
        LIMIT ?
        SQL
      find_by_sql([query, latitude.to_f, longitude.to_f, latitude.to_f, categoria.to_i, limit.to_i])
    end
  end
end
