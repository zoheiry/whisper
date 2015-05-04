class Pending < ActiveRecord::Base
	validates_uniqueness_of :u1_id, :scope => :u2_id
end
