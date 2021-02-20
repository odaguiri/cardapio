require 'roda'
require 'puma'
require 'pg' 
require 'logger'
require 'sequel/core'

module AuthService
class App < Roda
  DB = Sequel.connect(ENV.delete('DATABASE_URL'))
  DB.loggers << Logger.new($stdout)
  DB.freeze

  opts[:root] = File.dirname(__FILE__)

  plugin :render, escape: true
  plugin :hooks
  plugin :flash
  plugin :common_logger
  plugin :route_csrf

  secret = ENV.delete('SESSION_SECRET')
  plugin :sessions, :secret=>secret, :key=>'auth.session'

  plugin :rodauth, :json=>true, :csrf=>:route_csrf do
    db DB
    enable :change_login, :change_password, :close_account, :create_account,
           :lockout, :login, :logout, :remember, :reset_password, :verify_account,
           :otp, :recovery_codes, :sms_codes, :disallow_common_passwords,
           :disallow_password_reuse, :password_grace_period, :active_sessions, :jwt,
           :verify_login_change, :change_password_notify, :confirm_password,
           :email_auth
    enable :webauthn, :webauthn_login if ENV['WEBAUTHN']
    enable :webauthn_verify_account if ENV['WEBAUTHN_VERIFY_ACCOUNT']
    max_invalid_logins 2
    account_password_hash_column :ph
    title_instance_variable :@page_title
    only_json? false
    jwt_secret(secret)
    hmac_secret secret
  end

  plugin :error_handler do |e|
    @page_title = 'Internal Server Error'
    view :content=>"#{h e.class}: #{h e.message}<br />#{e.backtrace.map{|line| h line}.join("<br />")}"
  end

  plugin :not_found do
    @page_title = 'File Not Found'
    view :content=>''
  end

  route do |r|
    rodauth.load_memory
    rodauth.check_active_session
    r.rodauth
  end
  
  freeze
end
end