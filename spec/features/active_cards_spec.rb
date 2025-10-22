require 'rails_helper'

RSpec.feature "Active Cards", type: :feature, js: true do

  let!(:topic) { create(:topic, title: 'Example topic') }
  let!(:deck) { create(:deck, title: 'Example deck', topic:) }

  # TODO: Die Show/Edit View von Active Cards sollte anzeigen:
  # - Welches Level hat die Card?`
  # - In Welchen Tests wurde die Card abgefragt, und ob die EIngabe richtig/falsch war
  # - Wann die Nächste Abfrage ist
  scenario 'crud active cards' do
    # See empty index view
    visit root_path
    click_link 'Active Cards'

    expect(page)
      .to have_css('h1', text: 'ActiveCards')
      .and have_text('No elements found')

    # Create new card
    click_link 'New ActiveCard'
    expect(page)
      .to have_css('h1', text: 'New ActiveCard')
      .and have_field('Deck') # TODO: Was soll hier der default sein?
      .and have_md_field('Question')
      .and have_md_field('Answer')
      .and have_md_field('Explanation')

    click_button 'Save'
    within '.alert-danger' do
      expect(page)
        .to have_content("Question can't be blank")
        .and have_content("Answer can't be blank")
    end

    fill_md_field 'Question', with: 'This is a question'
    fill_md_field 'Answer', with: 'This is the answer'
    fill_md_field 'Explanation', with: 'This is the explanation'
    click_button 'Save'

    expect(page)
      .to have_css('.alert-success', text: 'Card successfully created!')
      .and have_current_path new_active_card_path

    # We can immediately create the next card
    fill_md_field 'Question', with: 'What is the meaning of life?'
    fill_md_field 'Answer', with: '42'
    fill_md_field 'Explanation', with: 'from Douglas Adams'
    click_button 'Save'

    expect(page)
      .to have_css('.alert-success', text: 'Card successfully created!')
      .and have_current_path new_active_card_path

    # See updated index view
    click_link 'Active Cards'
    expect(page).to have_css('h1', text: 'ActiveCards')

    table_rows = page.all('table tr')
    expect(table_rows.size).to eq(3)

    # TODO: Eventuell möchte ich noch den "Next Recal" anzeigen lassen.
    within table_rows[0] do |table_row|
      table_head = table_row.all('th')
      expect(table_head[1]).to have_content('Question')
      expect(table_head[2]).to have_content('Answer')
      expect(table_head[3]).to have_content('Level')
      expect(table_head[4]).to have_content('Last recal')
    end

    within table_rows[1] do |table_row|
      table_data = table_row.all('td')
      expect(table_data[1]).to have_content('What is the meaning of life?') # question
      expect(table_data[2]).to have_content('42') # answer
      expect(table_data[3]).to have_content('0') # level
      expect(table_data[4]).to have_content('') # last recal
    end

    within table_rows[2] do |table_row|
      table_data = table_row.all('td')
      expect(table_data[1]).to have_content('This is a question') # question
      expect(table_data[2]).to have_content('This is the answer') # answer
      expect(table_data[3]).to have_content('0') # level
      expect(table_data[4]).to have_content('') # last recal
    end

    # Edit active card
    within table_rows[1] do
      click_link 'Edit active card'
    end

    expect(page)
      .to have_css('h1', text: 'Editing Active Card')
      .and have_md_field('Question', with: 'What is the meaning of life?')
      .and have_md_field('Answer', with: '42')
      .and have_md_field('Explanation', with: 'from Douglas Adams')

    fill_md_field 'Question', with: 'Updated question'
    click_button 'Save'

    expect(page)
      .to have_css('.alert-success', text: 'Card successfully saved')
      .and have_md_field('Question', with: 'Updated question')
      .and have_md_field('Answer', with: '42')
      .and have_md_field('Explanation', with: 'from Douglas Adams')

    # Delete card
    click_link 'Back'
    table_rows = page.all('table tr')
    expect(table_rows.size).to eq(3)

    within table_rows[1] do
      click_link 'Delete active card'
    end

    accept_alert('Are you sure you want to delete this card?')
    expect(page).to have_css('.alert-success', text: 'Card deleted!')

    table_rows = page.all('table tr')
    expect(table_rows.size).to eq(2)
  end

end
