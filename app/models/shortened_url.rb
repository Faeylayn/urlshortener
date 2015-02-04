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
    new_short.save
    new_short
  end

  def self.find_url_by_short_url(url)
      self.where("short_url = ?", url).first
    end

  belongs_to(:submitter,
      :class_name => "User",
      :foreign_key => :submitter_id,
      :primary_key => :id
  )

  has_many(:visits,
      :class_name => "Visit",
      :foreign_key => :visited_url_id,
      :primary_key => :id
  )

  has_many :visitors, :through => :visits, :source => :visitors

  def num_clicks
    self.visits.count
  end

  def num_uniques
    self.visitors.distinct.count
  end

  def num_recent_uniques
    c = 10.minutes.ago
    self.visitors.where("visits.created_at >= ?", c).distinct.count
  end

end
