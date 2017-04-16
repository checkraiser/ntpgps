Dir["./models/*.rb"].each {|file| require file }

module Transactional
  def with_db
  	begin
	  ActiveRecord::Base.transaction do 
	  	yield
	  end
  	rescue Exception => e
  	  return { errors: e.message }
  	end
  end

  def call
  	with_db do 
  	  execute!
  	end
  end
end