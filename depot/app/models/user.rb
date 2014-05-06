class User < ActiveRecord::Base
	after_destroy :ensure_an_admin_remains

	validates :name, presence: true, uniqueness: true

  has_secure_password

  def ensure_an_admin_remains
  	if User.count.zero?
  		raise "Can't delete last user"
  	end
  end

  def self.authenticate(user_name, password)
    user = User.find_by(name: user_name)
    if user and user.authenticate(password)
      user
    end
  rescue ActiveRecord::RecordNotFound
    logger.debug ":::::::::::::::::::::::::::::::::::::::  rescue: no se encontro al usuario en el modelo"
  end
end
