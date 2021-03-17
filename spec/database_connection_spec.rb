require 'database_connection'

describe DatabaseConnection do
  describe '.setup' do
    it 'Sets up a connection to the database' do
      expect(PG).to receive(:connect).with(dbname: 'bookmark_manager_test', user: 'postgres', password: 'Pg5429671')
      DatabaseConnection.setup('bookmark_manager_test')
    end
  end

  describe '.query' do
    it "executes a query via PG" do
      connection = DatabaseConnection.setup('bookmark_manager_test')
      expect(connection).to receive(:exec).with('SELECT * FROM bookmarks;')
      DatabaseConnection.query("SELECT * FROM bookmarks;")
    end
  end
end
