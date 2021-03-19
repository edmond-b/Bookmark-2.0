require 'pg'

p "Setting up test database..."

def setup_test_database
  connection = PG.connect(user: 'postgres', password: 'Pg5429671', dbname: 'bookmark_manager_test')
  connection.exec("TRUNCATE bookmarks, comments, tags, bookmark_tags, users;")
end
