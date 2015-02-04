class Visit < ActiveRecord::Base
  validates :visitor_id, :visited_url_id, :presence => true

  def self.record_visit!(user, shortened_url)
    new_visit = Visit.new
    new_visit.visitor_id = user.id
    new_visit.visited_url_id = shortened_url.id
    new_visit.save
    new_visit
  end

  belongs_to(:visitors,
      :class_name => "User",
      :foreign_key => :visitor_id,
      :primary_key => :id
  )

  belongs_to(:visited_urls,
      :class_name => "ShortenedUrl",
      :foreign_key => :visited_url_id,
      :primary_key => :id
  )

end
