module Transactional
  def with_db
  	ActiveRecord::Base.transaction do 
  	  yield
  	end
  end
end