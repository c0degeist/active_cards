require 'rails_helper'

RSpec.feature "Dashboard", type: :feature, js: true do

  let!(:topic) { create(:topic, title: 'Example topic') }

  scenario 'index view shows all tests (finished, canceled)' do
    # TODO
  end

  scenario 'result page of a test' do
    # TODO
  end

end
