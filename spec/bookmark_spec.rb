require 'bookmark'
require 'pg'
require 'database_helper'

describe Bookmark do
  describe '.all' do
    it 'returns all bookmarks' do
      connection = PG.connect(user: 'postgres', password: 'Pg5429671', dbname: 'bookmark_manager_test')

      bookmark = Bookmark.create(url: "http://www.makersacademy.com", title: "Makers Academy")
      Bookmark.create(url: "http://www.destroyallsoftware.com", title: "Destroy All Software")
      Bookmark.create(url: "http://www.google.com", title: "Google")

      bookmarks = Bookmark.all
      expect(bookmarks.length).to eq(3)
      expect(bookmarks.first).to be_a(Bookmark)
      expect(bookmarks.first.id).to eq(bookmark.id)
      expect(bookmarks.first.title).to eq('Makers Academy')
      expect(bookmarks.first.url).to eq("http://www.makersacademy.com")
    end
  end

  describe '.create' do
    it 'creates a new bookmark' do
      bookmark = Bookmark.create(url: 'http://www.testbookmark.com', title: 'Test Bookmark')
      persisted_data = persisted_data(table: 'bookmarks', id: bookmark.id)

      expect(bookmark).to be_a(Bookmark)
      expect(bookmark.id).to eq(persisted_data.first['id'])
      expect(bookmark.title).to eq('Test Bookmark')
      expect(bookmark.url).to eq('http://www.testbookmark.com')
    end

    it "does not create a new bookmark if URL is not valid" do
      Bookmark.create(url: 'not a real URL', title: 'not a real bookmark')
      expect(Bookmark.all).to be_empty
    end
  end

  describe '.delete' do
    it 'deletes the given bookmark' do
      bookmark = Bookmark.create(title: 'Makers Academy', url: 'http://www.makersacademy.com')
      Bookmark.delete(id: bookmark.id)
      expect(Bookmark.all.length).to eq(0)
    end
  end

  describe '.update' do
    it 'Updates the bookmark with new data' do
      bookmark = Bookmark.create(title: 'Makers Academy', url: 'http://www.makersacademy.com')
      updated_bookmark = Bookmark.update(id: bookmark.id, url: 'http://www.snakersacademy.com', title: 'Snakers Academy')

      expect(updated_bookmark).to be_a Bookmark
      expect(updated_bookmark.id).to eq bookmark.id
      expect(updated_bookmark.title).to eq 'Snakers Academy'
      expect(updated_bookmark.url).to eq 'http://www.snakersacademy.com'
    end
  end

  describe '.find' do
    it 'returns the requested bookmark object' do
      bookmark = Bookmark.create(title: 'Makers Academy', url: 'http://www.makersacademy.com')

      result = Bookmark.find(id: bookmark.id)

      expect(result).to be_a Bookmark
      expect(result.id).to eq bookmark.id
      expect(result.title).to eq 'Makers Academy'
      expect(result.url).to eq 'http://www.makersacademy.com'
    end
  end

  let(:comment_class) { double(:comment_class) }

  describe '.comments' do
    it 'returns a list of comments o the bookmark' do
      bookmark = Bookmark.create(title: 'Makers Academy', url: 'http://www.makersacademy.com')
      DatabaseConnection.query("INSERT INTO comments (id, text, bookmark_id) VALUES(1, 'Test comment', #{bookmark.id})")
      comment = bookmark.comments.first
      expect(comment.text).to eq 'Test comment'
    end

    it 'calls .where on the comment class' do
      bookmark = Bookmark.create(title: 'Makers Academy', url: 'http://www.makersacademy.com')
      expect(comment_class).to receive(:where).with(bookmark_id: bookmark.id)
      bookmark.comments(comment_class)
    end
  end

  let(:tag_class) { double(:tag_class) }

  describe '.tags' do
    it 'calls .where on the Tag class' do
      bookmark = Bookmark.create(title: 'Makers Academy', url: 'http://www.makersacademy.com')
      expect(tag_class).to receive(:where).with(bookmark_id: bookmark.id)
      bookmark.tags(tag_class)
    end
  end

  describe '.where' do
    it 'returns bookmarks with the given tag id' do
      bookmark = Bookmark.create(url: "http://www.makersacademy.com", title: "Makers Academy")
      tag1 = Tag.create(content: 'test tag 1')
      tag2 = Tag.create(content: 'test tag 2')
      BookmarkTag.create(bookmark_id: bookmark.id, tag_id: tag1.id)
      BookmarkTag.create(bookmark_id: bookmark.id, tag_id: tag2.id)

      bookmarks = Bookmark.where(tag_id: tag1.id)
      result = bookmarks.first

      expect(bookmarks.length).to eq 1
      expect(result).to be_a Bookmark
      expect(result.id).to eq bookmark.id
      expect(result.title).to eq bookmark.title
      expect(result.url).to eq bookmark.url
    end
  end
end
