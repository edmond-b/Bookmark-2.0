require 'pg'

feature 'Adding a new bookmark' do
  scenario 'A user acn add a bookmark to bookmark manager' do
    visit('/bookmark/new')
    fill_in('url', with: 'http://testbookmark.com')
    click_button('Submit')
    expect(page).to have_content('http://testbookmark.com')
  end
end
