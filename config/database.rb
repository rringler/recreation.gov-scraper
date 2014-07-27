ActiveRecord::Base.configurations[:development] = {
  :adapter   => 'postgresql',
  :database  => 'recreation_gov_scraper_development',
  # :username  => '',
  # :password  => '',
  :host      => 'localhost',
  :port      => 5432

}

ActiveRecord::Base.configurations[:production] = {
  :adapter   => 'postgresql',
  :database  => ENV['POSTGRESQL_DATABASE'],
  :username  => ENV['POSTGRESQL_USERNAME'],
  :password  => ENV['POSTGRESQL_PASSWORD'],
  :host      => ENV['POSTGRESQL_HOST'],
  :port      => ENV['POSTGRESQL_PORT']

}

ActiveRecord::Base.configurations[:test] = {
  :adapter   => 'postgresql',
  :database  => 'recreation_gov_scraper_test',
  :username  => 'root',
  :password  => '',
  :host      => 'localhost',
  :port      => 5432

}

ActiveRecord::Base.configurations['default_env'] =
  ActiveRecord::Base.configurations[ENV['RACK_ENV'].to_sym]

# Setup our logger
ActiveRecord::Base.logger = logger

if ActiveRecord::VERSION::MAJOR.to_i < 4
  # Raise exception on mass assignment protection for Active Record models.
  ActiveRecord::Base.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL).
  ActiveRecord::Base.auto_explain_threshold_in_seconds = 0.5
end

# Doesn't include Active Record class name as root for JSON serialized output.
ActiveRecord::Base.include_root_in_json = false

# Store the full class name (including module namespace) in STI type column.
ActiveRecord::Base.store_full_sti_class = true

# Use ISO 8601 format for JSON serialized times and dates.
ActiveSupport.use_standard_json_time_format = true

# Don't escape HTML entities in JSON, leave that for the #json_escape helper
# if you're including raw JSON in an HTML page.
ActiveSupport.escape_html_entities_in_json = false

# Now we can establish connection with our db.
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[Padrino.env])

# Timestamps are in the utc by default.
ActiveRecord::Base.default_timezone = :utc
