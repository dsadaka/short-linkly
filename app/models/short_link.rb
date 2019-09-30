class ShortLink < ApplicationRecord
  validates_presence_of :long_link
  validates_presence_of :user_id
  validates_uniqueness_of :long_link, scope: :user_id
  validates :long_link, http_url: true

  def encoded_id
    self.id.to_s(36)
  end

  def self.decoded_id(eid)
    eid.to_i(36)
  end

  def self.find_by_encoded_id(eid)
    self.find(self.decoded_id(eid))
  end
end
