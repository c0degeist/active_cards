# Learning:
# Wenn dein Model nicht den Typischen CRUD Lifecycle hat, ist es vollkommen legitim vom CRUD Pattern bei Controllern ab zu weichen
# Muss muss nicht versuchen auf Krampf "CRUD" zu machen.
# In dem Fall, gibt es
# - Frage sehen -> #show -> zeigt je nach state unterschiedliche dinge an.
# - Eingabe tätigen -> patch #answer
# - Bewerten -> patch #review -> redirect auf show

module Tests
  class CardsController < ApplicationController
    before_action :load_test

    def show
      load_test_card
    end

    def answer
      load_test_card
      @test_card.user_answer = test_card_params[:user_answer]

      # Das schaut super weird aus:
      if @test_card.answered
        redirect_to action: :show
      else
        render :show
      end
    end

    def review
      load_test_card
      @test_card.answered_correctly = test_card_params[:answered_correctly]

      # Das schaut super weird aus:
      if @test_card.reviewed
        redirect_to action: :show
      else
        render :show
      end
    end

    private

    def build_test_card
      @test_card ||= test_card_scope.new
      @test_card.attributes = test_card_params
    end

    def load_test
      @test = Test.find(params[:test_id])
    end

    def load_test_card
      @test_card = Test::Card.find(params[:id])
    end

    def test_card_params
      # NOTE: Vmtl kommen die parameter einfach als "card" an?
      params.require(:test_card).permit(:user_answer, :answered_correctly)
    rescue ActionController::ParameterMissing
      {}
    end

  end
end
