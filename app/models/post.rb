class Post < ApplicationRecord
  belongs_to :seed1, class_name: 'Seed', :foreign_key => 'seed1_id'
  belongs_to :seed2, class_name: 'Seed', :foreign_key => 'seed2_id'
end
