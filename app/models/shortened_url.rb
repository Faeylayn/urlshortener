class ShortenedUrl < ActiveRecord::Base
  include SecureRandom
  validates :short_url, :long_url, :submitter_id, :presence => true
  validates :short_url, :long_url, :uniqueness => true

  def self.random_code
    code = nil
    until !self.exists?(:short_url => code) && !code.nil?
      code = SecureRandom.urlsafe_base64(12)
    end
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    new_short = ShortenedUrl.new
    new_short.long_url = long_url
    new_short.short_url = ShortenedUrl.random_code
    new_short.submitter_id = user.id
    new_short.save!
  end


end
