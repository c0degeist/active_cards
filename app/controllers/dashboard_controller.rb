class DashboardController < ApplicationController

  # TODO: Vlt möchte ich hier etwas "Objektigeres" einführen, mit dem ich spreche.
  # Test::Dashboard
  # Und in der #Index action machen wir nur noch build_dashboard
  # dashboard.pending_tests
  # dashboard.started_tests
  # dashboard.last_finished_tests
  def index
    build_pending_tests
    load_started_tests
    load_finished_tests
  end

  private

  def build_pending_tests
    @pending_tests ||= Test::Factory.new.build_all_pending_tests
  end

  def load_started_tests
    @started_tests ||= Test.started
  end

  def load_finished_tests
    @finished_tests ||= Test.finished.last(5)
  end

end
