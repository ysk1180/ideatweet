class Seed < ApplicationRecord
  has_many :seed1_posts, class_name: 'Post', :foreign_key => 'seed1_id'
  has_many :seed2_posts, class_name: 'Post', :foreign_key => 'seed2_id'
end
