require 'pg'

class Bookmark
  def self.all
    connection = PG.connect(user: 'postgres', password: 'Pg5429671', dbname: 'bookmark_manager')
    result = connection.exec("SELECT * FROM bookmarks;")
    result.map { |bookmark| bookmark['url'] }
  end
end
