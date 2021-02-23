# core
require 'pg' 
require 'logger'
require 'mail'
require 'securerandom'

# bundle
require 'roda'
require 'puma'
require 'sequel/core'

module AuthService
class App < Roda
  database_name = ENV.delete('DATABASE_NAME')
  secret = ENV.delete('SESSION_SECRET')

  DB = Sequel.connect(ENV.delete('DATABASE_URL'))
  DB.loggers << Logger.new($stdout)

  ::Mail.defaults do
    delivery_method :test
  end

  opts[:root] = File.dirname(__FILE__)

  MAILS = {}
  MUTEX = Mutex.new

  plugin :hooks
  plugin :common_logger
  plugin :rodauth, :json=>true do
    db DB
    enable :login, :logout, :create_account, :close_account, :change_password, :lockout, :change_login, :json, :jwt, :email_auth 
    # if using the disallow_password_reuse feature:
    # previous_password_hash_table Sequel.lit("#{DATABASE_NAME}_password.account_previous_password_hashes")
    password_hash_table "#{database_name}_password.account_password_hashes"
    password_hash_table Sequel[:auth_password][:account_password_hashes]
    function_name do |name|
      "#{database_name}_password.#{name}"
    end
    max_invalid_logins 2
    use_database_authentication_functions? true
    only_json? true
    jwt_secret secret
    hmac_secret secret
  end

  plugin :error_handler do |e|
    {
      error: "#{h e.class}: #{h e.message}",
      detail: e.backtrace.map{|line| h line}.join(",")
    }
  end

  plugin :not_found do
    { error: :not_found }
  end

  def last_mail_sent
    MUTEX.synchronize{MAILS.delete(rodauth.session_value)}
  end

  after do
    Mail::TestMailer.deliveries.each do |mail|
      MUTEX.synchronize{MAILS[rodauth.session_value] = mail}
    end
    Mail::TestMailer.deliveries.clear
  end

  route do |r|
    r.rodauth
  end
  
  freeze
end
end