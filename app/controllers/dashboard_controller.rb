class DashboardController < ApplicationController

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
