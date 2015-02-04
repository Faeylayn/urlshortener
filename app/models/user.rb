class User < ActiveRecord::Base
  validates :email, :uniqueness => true
  validates :email, :presence => true

  has_many(:submitted_urls,
      :class_name => "ShortenedUrl",
      :foreign_key => :submitter_id,
      :primary_key => :id
  )

  has_many(:visits,
      :class_name => "Visit",
      :foreign_key => :visitor_id,
      :primary_key => :id
  )

  has_many :visited_urls, :through => :visits, :source => :visited_urls

  def self.find_user_by_email(email)
      self.where("email = ?", email).first
    end

end
