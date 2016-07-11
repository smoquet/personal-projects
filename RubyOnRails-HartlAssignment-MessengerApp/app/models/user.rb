class User < ActiveRecord::Base
  # ??? this "create[s] an accessible attribute"
  attr_accessor :remember_token
  # before_save downcases the input so that it isnt case sensitive anymore
  # it could aslo have been: self.email = self.email.downcase. but that is optional
  before_save {self.email = email.downcase}
  validates :name, presence: true, length: {maximum:50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
                    # ruby infers that uniqueness should be true, so that isnt defined
                    # after "uniqueness: ", case sensitivity is set to false so that it still comes up
                    # with a match (and thus a failure) if only the case differs from
                    # the email duplicate


  has_secure_password
  # this method adds the functionality of authenticating users, hashing passwords into the database in
  # a form where it is impossible to trace back the password itself, and a pair of viutal attributes( that is
  # an attribute exisitng only in the model itself and not in the databse) that consists of two strings thath
  # can be checked for similarity string1 == string 2. (password and password_confirmation). it also requires
  # a validation that these both match, otherwise it fails (as will your tests).
  # for this method to work the model needs a 'password_digest' attribute (collumn in table). where
  # the hashed password is entered

  # de allow_nil zorgt ervoor dat het wachtwoord bij een edit user niet
  # ingevoerd hoeft te worden. zodat iemand zijn email kan veranderen zonder
  # wachtwoord opniuew te hoeven setten
  validates :password, presence: true, length: {minimum:6}, allow_nil: true

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  # this is our own wrapper method for digesting a password. it is used to
  # create a valid fixture (fake user) in test/fixtures/users.yml for testing purposes
  # later it is used in 8.4.5

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remember a user in the database for use in persistent sessions ???
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # forget a user by updating the remember_digest with the value nil
  def forget
    update_attribute(:remember_digest, nil)
  end
end
