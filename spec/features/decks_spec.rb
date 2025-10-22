require 'rails_helper'

RSpec.feature "Decks", type: :feature, js: true do

  let!(:topic) { create(:topic, title: 'Example topic') }

  scenario 'crud decks' do
    # See empty index view
    visit root_path
    click_link 'Decks'
    expect(page)
      .to have_css('h1', text: 'Decks')
      .and have_text('No elements found')

    # Create new deck
    click_link 'New Deck'
    expect(page)
      .to have_css('h1', text: 'New deck')
      .and have_field('Title') # TODO: Wie teste ich dass das Feld initial leer ist?

    click_button 'Save'
    within '.alert-danger' do
      expect(page)
        .to have_content("Topic must exist")
        .and have_content("Title can't be blank")
        .and have_content("Topic can't be blank")
    end

    fill_in 'Title', with: 'My new deck'
    select 'Example topic', from: 'Topic'
    click_button 'Save'
    expect(page)
      .to have_css('.alert-success', text: 'Deck successfully created!')
      .and have_css('h1', text: 'Edit Deck "My new deck"')
      .and have_field('Title', with: 'My new deck')
      # .and have_field('Topic', with: 'Example topic') # TODO
      .and have_content('ActiveCards: 0')

    # See updated index view
    click_link 'Back to decks'
    expect(page).to have_css('h1', text: 'Decks')

    table_rows = page.all('table tr')
    expect(table_rows.size).to eq(2)

    # TODO: Eventuell möchte ich noch das Assoziierte Topic mit anzeigen.
    within table_rows[0] do |table_row|
      table_data = table_row.all('th')
      expect(table_data[1]).to have_content('Title')
      expect(table_data[2]).to have_content('Cards')
    end

    within table_rows[1] do |table_row|
      table_data = table_row.all('td')
      expect(table_data[1]).to have_content('My new deck') # Title
      expect(table_data[2]).to have_content('0') # Cards
    end

    # Edit deck
    click_link 'My new deck'
    expect(page).to have_css('h1', text: 'Edit Deck "My new deck"')

    fill_in 'Title', with: 'Updated deck title'
    click_button 'Save'
    expect(page)
      .to have_css('.alert-success', text: 'Deck successfully updated!')
      .and have_css('h1', text: 'Edit Deck "Updated deck title"')
      .and have_field('Title', with: 'Updated deck title')

    # Delete deck
    click_link 'Back to decks'
    click_link 'Delete deck'
    accept_alert('Are you sure you want to delete this deck?')
    expect(page).to have_css('.alert-success', text: 'Deck was successfully destroyed.')
  end

  scenario 'Add cards to a deck' do

  end

end
