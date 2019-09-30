class ShortLink < ApplicationRecord
  validates_presence_of :long_link
  validates_presence_of :user_id
  validates_uniqueness_of :long_link, scope: :user_id
  validates :long_link, http_url: true

  after_initialize :init
  after_find :increment_use_count

  def init
    self.use_count ||= 1
  end

  def increment_use_count
    self.use_count += 1
    save!
  end

  def encoded_id
    self.id.to_s(36)
  end

  def self.decoded_id(eid)
    eid.to_i(36)
  end

  def self.find_by_encoded_id(eid)
    self.find(self.decoded_id(eid.to_s))
  end

  def self.find_quietly(eid)
    skip_callback(:find, :after, :increment_use_count)
    short_link =  case eid
                  when :last
                    ShortLink.last
                  when :first
                    ShortLink.first
                  else
                    ShortLink.find_by_encoded_id(eid) rescue 0
                  end
    set_callback(:find, :after, :increment_use_count)
    short_link
  end

end
