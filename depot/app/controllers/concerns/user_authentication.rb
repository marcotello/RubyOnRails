module UserAuthentication
	extend ActiveSupport::Concern
	private
	def authenticate_user(user_name, password)
		user = User.find_by(name: user_name)
  		if user and user.authenticate(password)
			user
		end
	rescue ActiveRecord::RecordNotFound
		logger.debug ":::::::::::::::::::::::::::::::::::::::  rescue: no se encontro al usuario en el modelo"
	end
end
