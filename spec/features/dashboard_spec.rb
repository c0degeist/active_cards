require 'rails_helper'

RSpec.feature "Dashboard", type: :feature, js: true do

  scenario 'dashboard shows state for each topic' do
    topic_pending = create(:topic, title: 'Topic with pending cards')
    _topic_empty = create(:topic, title: 'Topic without any cards')
    topic_not_ready = create(:topic, title: 'Topic not ready yet')

    deck_pending_one = create(:deck, topic: topic_pending)
    deck_pending_two = create(:deck, topic: topic_pending)
    deck_not_ready = create(:deck, topic: topic_not_ready)

    create(:active_card, :pending, deck: deck_pending_one)
    create(:active_card, :pending, deck: deck_pending_two)
    create(:active_card, :pending, deck: deck_pending_two)
    create(:active_card, :done, deck: deck_not_ready)

    visit root_path
    expect(page).to have_css('h2', text: 'Pending Tests')

    pending_tests_table = find('.pending-tests-table')
    pending_tests_rows = pending_tests_table.all('tbody tr')
    expect(pending_tests_rows.size).to eq 3

    # TODO: Vlt willst du die Reihenfolge in der die Topics erscheinen anpassen?
    within pending_tests_rows[0] do |row|
      columns = row.all('td')
      expect(columns[0]).to have_content 'Topic with pending cards' # title
      expect(columns[1]).to have_content '2' # decks
      expect(columns[2]).to have_content '3' # cards
      expect(columns[3]).to have_content 'Es stehen 3 Cards zur Abfrage bereit' # cards
    end

    within pending_tests_rows[1] do |row|
      columns = row.all('td')
      expect(columns[0]).to have_content 'Topic without any cards' # title
      expect(columns[1]).to have_content '0' # decks
      expect(columns[2]).to have_content '0' # cards
      expect(columns[3]).to have_content 'Dieses Deck hat noch keine Cards' # cards
    end

    within pending_tests_rows[2] do |row|
      columns = row.all('td')
      expect(columns[0]).to have_content 'Topic not ready yet' # title
      expect(columns[1]).to have_content '1' # decks
      expect(columns[2]).to have_content '1' # cards
      expect(columns[3]).to have_content 'Nächster Test in 1 Tagen' # cards
    end
  end

  # TODO: Vlt lebt diese spec lieber unter tests_spec.rb
  # Vmtl die Wichtigste Spec in der Anwendung. Deckt die größte funktionalität ab.
  # Lässt sich vermutlich sauberer in 3 - 4 Tests unterteilen die mehr Pfade abdecken.
  scenario 'start and finish a pending test' do
    disable_randomized_tests
    topic = create(:topic, title: 'Example topic')
    deck = create(:deck, title: 'Example deck', topic:)
    # 3.times { create(:active_card, :pending, deck:) }

    # TODO: Ich möchte in der Anwendung vermutlich folgende Umbenennungen vornehmen:
    # ActiveCard -> TestQuestionTemplate
    # Card -> TestQuestion
    # Damit wird leichter verständlich dass:
    # Ein Test hat viele TestQuestions; Eine TestQuestion gehört jeweils zu einem TestQuestionTemplate.
    # Außerdem: Brauche ich logidze?
    create(:active_card, :pending, deck:,
      question: 'This is the first question',
      answer: 'This is the first answer',
      explanation: 'This is the first explanation',
    )

    create(:active_card, :pending, deck:,
      question: 'This is the second question',
      answer: 'This is the second answer',
      explanation: 'This is the second explanation',
    )

    visit root_path
    expect(page).to have_css('h2', text: 'Pending Tests')

    # TODO: Frage in dev-fragen: Ist es ok einem Element eine CSS Klasse zu geben, nur um sie in einem Test wieder zu finden?
    pending_tests_table = find('.pending-tests-table')
    within pending_tests_table do
      click_link 'Test Starten'
    end

    # TODO: Der Progress sollte angezeigt werden (z.B. Card 2/10, vlt sogar eine Bootstrap Progress Bar)
    sleep(0.1) # TODO: Schau wie Michael Capybara Lockstep in Wilson umgesetzt hat.
    expect(page)
      .to have_css('h1', text: 'TestCard')
      .and have_md_field('Question', with: 'This is the first question')
      .and have_md_field('User answer', with: '')
      .and have_no_md_field('Answer') # TODO: Das Feld nach "Solution" umbenennen.
      .and have_no_md_field('Explanation')

    # TODO: Spec das Question nur readable ist.
    fill_md_field('User answer', with: 'My wrong answer')
    click_button 'Lösung vergleichen'
    sleep(0.1)

    expect(page)
      .to have_md_field('Question', with: 'This is the first question')
      .and have_md_field('Answer', with: 'This is the first answer')
      .and have_md_field('User answer', with: 'My wrong answer')
      .and have_md_field('Explanation', with: 'This is the first explanation')

    click_button 'false'
    sleep(0.1)

    # TODO: In der UI sollte sich etwas verändern auf je nachdem ob ich true/false gewählt habe.

    click_link 'Next Card'
    sleep(0.1)

    expect(page)
      .to have_md_field('Question', with: 'This is the second question')
      .and have_md_field('User answer', with: '')
      .and have_no_md_field('Answer')
      .and have_no_md_field('Explanation')

    fill_md_field('User answer', with: 'This is my second answer')
    click_button 'Lösung vergleichen'
    sleep(0.1)

    expect(page)
      .to have_md_field('Question', with: 'This is the second question')
      .and have_md_field('User answer', with: 'This is my second answer')
      .and have_md_field('Answer', with: 'This is the second answer')
      .and have_md_field('Explanation', with: 'This is the second explanation')

    click_button 'true'
    sleep(0.1)

    # TODO: In der UI sollte sich etwas verändern auf je nachdem ob ich true/false gewählt habe.

    click_link 'Test abschließen'
    sleep(0.1)

    expect(page)
      .to have_css('h1', text: 'Test vom') # TODO: Timecop einbinden und auf Datum schauen.
      .and have_content('Es wurden 1 von 2 Fragen richtig beantwortet (50%)')

    question_containers = all('.accordion-item')

    click_button 'Question 1'
    within question_containers[0] do |question_container|
      expect(question_container).to have_content 'This is the first question'
      # TODO: Im Question Container möchte ich folgende Sachen sehen:
      # - Meine Eingabe
      # - Lösung
      # - Farbliche Kennzeichnung ob Korrekt oder Falsch
      # - Level
      # - Explanation
      # - Rating der Card (z.B. 6 von 10 mal richtig beantwortet -> 60% Sicherheit)
    end

    click_button 'Question 2'
    within question_containers[1] do |question_container|
      expect(question_container).to have_content 'This is the second question'
    end

    # See Updated Dashboard
    click_link 'Home'
    pending_tests_table = find('.pending-tests-table')

    # Falsch beantwortete Card ist wieder bereit zur Abfrage.
    expect(pending_tests_table).to have_content 'Es stehen 1 Cards zur Abfrage bereit'

    finished_tests_table = find('.finished-tests-table')
    finished_tests = finished_tests_table.all('tbody tr')

    expect(finished_tests.size).to eq 1
    within finished_tests[0] do |row|
      columns = row.all('td')
      expect(columns[0]).to have_content 'Example topic'
      # expect(columns[1]).to have_content '2025' TODO: Timecop integrieren und auf den Tag schauen.
      expect(columns[2]).to have_content '2'
      expect(columns[3]).to have_content 'finished'
      expect(columns[4]).to have_content 'Result'
    end
  end

  scenario 'cancel test and continue later' do
    # TODO
  end

  scenario 'dashboard shows last finished tests' do
    # TODO
  end

end
