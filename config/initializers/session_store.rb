# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_full_rss_session',
  :secret      => '274c243607720b593ee7875bea86149713d9641ecc5cc0e140988aa1f9c453975f4b00fa4345b71fa7115e337e6930c520f8d9eed9abefb7e75c838e2ab65b3c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
