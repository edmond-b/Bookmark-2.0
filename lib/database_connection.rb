require 'pg'

class DatabaseConnection
  def self.setup(dbname, password='Pg5429671', user='postgres')
    @connection = PG.connect(dbname: dbname, user: user, password: password)
  end
  
  def self.query(sql)
    @connection.exec(sql)
  end
end
