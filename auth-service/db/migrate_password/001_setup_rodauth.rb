require 'rodauth'
require 'rodauth/migrations'
require 'byebug'

Sequel.migration do
  up do
    database_name = get(Sequel.lit('current_database()')).to_sym
    create_table(:account_password_hashes) do
      foreign_key :id, Sequel[database_name][:accounts], :primary_key=>true, :type=>:Bignum
      String :password_hash, :null=>false
    end
    Rodauth.create_database_authentication_functions(self, :table_name=>Sequel.lit("#{database_name}_password.account_password_hashes"))

    user = get(Sequel.lit('current_user')).sub(/_password\z/, '')
    run "GRANT INSERT, UPDATE, DELETE ON #{database_name}_password.account_password_hashes TO #{user}"
    run "GRANT SELECT(id) ON #{database_name}_password.account_password_hashes TO #{user}"
    run "GRANT EXECUTE ON FUNCTION rodauth_get_salt(int8) TO #{user}"
    run "GRANT EXECUTE ON FUNCTION rodauth_valid_password_hash(int8, text) TO #{user}"

    # if using the disallow_password_reuse feature:
    create_table(:account_previous_password_hashes) do
      primary_key :id, :type=>:Bignum
      foreign_key :account_id, Sequel[database_name][:accounts], :type=>:Bignum
      String :password_hash, :null=>false
    end
    Rodauth.create_database_previous_password_check_functions(self, :table_name=>Sequel.lit("#{database_name}_password.account_previous_password_hashes"))

    user = get(Sequel.lit('current_user')).sub(/_password\z/, '')
    run "GRANT INSERT, UPDATE, DELETE ON account_previous_password_hashes TO #{user}"
    run "GRANT SELECT(id, account_id) ON account_previous_password_hashes TO #{user}"
    run "GRANT USAGE ON account_previous_password_hashes_id_seq TO #{user}"
    run "GRANT EXECUTE ON FUNCTION rodauth_get_previous_salt(int8) TO #{user}"
    run "GRANT EXECUTE ON FUNCTION rodauth_previous_password_hash_match(int8, text) TO #{user}"
  end

  down do
    database_name = get(Sequel.lit('current_database()')).to_sym

    Rodauth.drop_database_previous_password_check_functions(self, :table_name=>Sequel.lit("#{database_name}_password.account_previous_password_hashes"))
    Rodauth.drop_database_authentication_functions(self, :table_name=>Sequel.lit("#{database_name}_password.account_password_hashes"))
    drop_table(Sequel.lit("#{database_name}_password.account_previous_password_hashes"), Sequel.lit("#{database_name}_password.account_password_hashes"))
  end
end