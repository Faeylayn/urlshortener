class TagTopic < ActiveRecord::Base
  validates :topic, :presence => true
  validates :topic, :uniqueness => true


end
