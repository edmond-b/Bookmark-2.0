require 'pg'

class Bookmark
  def self.all
    if ENV['ENVIRONMENT'] = 'test'
      connection = PG.connect(user: 'postgres', password: 'Pg5429671', dbname: 'bookmark_manager_test')
    else
      connection = PG.connect(user: 'postgres', password: 'Pg5429671', dbname: 'bookmark_manager')
    end
    
    result = connection.exec("SELECT * FROM bookmarks;")
    result.map { |bookmark| bookmark['url'] }
  end
end
