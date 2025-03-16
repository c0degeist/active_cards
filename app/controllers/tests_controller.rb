class TestsController < ApplicationController

  def index
    load_tests
  end

  def new
    build_test
  end

  def create
    build_test

    if @test.save
      redirect_to @test
    else
      flash[:error] = "Test konnte nicht gespeichert werden"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    load_test

    if @test.finished?
      render "show"
    else
      redirect_to test_card_path(@test, @test.next_card)
    end
  end

  def finish
    load_test

    if @test.finish
      redirect_to action: :show
    else
      # Wie komme ich hier rein?
      # Wie gehe ich damit um wenn #finish fehl schlägt
      # Vmtl will ich die errors im @test anzeigen.
    end
  end

  private

  def load_test
    @test = Test.find(params[:id])
  end

  def build_test
    @test ||= Test.new
    @test.attributes = test_params
  end

  def test_params
    params.require(:test).permit(:topic_id)
  rescue ActionController::ParameterMissing
    {}
  end

  def load_tests
    @tests = test_scope.to_a
  end

  def test_scope
    Test.all
  end

end
