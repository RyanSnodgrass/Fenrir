require 'database_cleaner'
RSpec.configure do |config|
  # additional factory_girl configuration
  config.include FactoryGirl::Syntax::Methods
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner[:neo4j, connection:
    {
      type: :server_db, path: 'http://localhost:7475'
    }
  ]
  config.before(:suite) do
    begin
      # DatabaseCleaner.clean
      # FactoryGirl.lint
    ensure
      # DatabaseCleaner.clean
    end
  end
end
