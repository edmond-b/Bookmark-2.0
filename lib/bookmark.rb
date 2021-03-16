require 'pg'

class Bookmark
  attr_reader :id, :url, :title

  def initialize(id:, url:, title:)
    @id = id
    @url = url
    @title = title
  end

  def self.all
    if ENV['ENVIRONMENT'] = 'test'
      connection = PG.connect(user: 'postgres', password: 'Pg5429671', dbname: 'bookmark_manager_test')
    else
      connection = PG.connect(user: 'postgres', password: 'Pg5429671', dbname: 'bookmark_manager')
    end
    result = connection.exec("SELECT * FROM bookmarks;")
    result.map do |bookmark|
      Bookmark.new(id: bookmark['id'], url: bookmark['url'], title: bookmark['title'])
    end
  end

  def self.create(url:, title:)
    if ENV['ENVIRONMENT'] = 'test'
      connection = PG.connect(user: 'postgres', password: 'Pg5429671', dbname: 'bookmark_manager_test')
    else
      connection = PG.connect(user: 'postgres', password: 'Pg5429671', dbname: 'bookmark_manager')
    end
    result = connection.exec("INSERT INTO bookmarks (url, title) VALUES('#{url}', '#{title}') RETURNING id, url, title")
    Bookmark.new(id: result[0]['id'], url: result[0]['url'], title: result[0]['title'])
  end

  def self.delete(id:)
    if ENV['ENVIRONMENT'] = 'test'
      connection = PG.connect(user: 'postgres', password: 'Pg5429671', dbname: 'bookmark_manager_test')
    else
      connection = PG.connect(user: 'postgres', password: 'Pg5429671', dbname: 'bookmark_manager')
    end
    connection.exec("DELETE FROM bookmarks WHERE id = #{id}")
  end
end
