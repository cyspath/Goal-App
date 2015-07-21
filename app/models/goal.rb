class Goal < ActiveRecord::Base

  validates :title, :author, presence: true

  belongs_to :author, foreign_key: :user_id, class_name: User


end
