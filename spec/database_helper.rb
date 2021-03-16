require 'pg'

def persisted_data(id:)
  connection = connection = PG.connect(user: 'postgres', password: 'Pg5429671', dbname: 'bookmark_manager_test')
  result = connection.query("SELECT * FROM bookmarks WHERE id = #{id};")
  result.first
end
