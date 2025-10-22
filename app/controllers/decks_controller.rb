class DecksController < ApplicationController
  def index
    load_decks
  end

  def show
    redirect_to action: :edit
  end

  def new
    build_deck
  end

  def edit
    load_deck
  end

  def create
    build_deck

    if @deck.save
      flash[:success] = "Deck successfully created!"
      redirect_to @deck
    else
      # TODO: styling für error flashes festlegen.
      flash[:error] = "Deck could not be created"
      render "new", status: :unprocessable_entity
    end
  end

  def update
    load_deck
    build_deck

    if @deck.save
      flash[:success] = "Deck successfully updated!"
      redirect_to @deck
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    load_deck
    @deck.destroy!
    flash[:success] = "Deck was successfully destroyed."
    redirect_to decks_path, status: :see_other
  end

  private

  def build_deck
    @deck ||= deck_scope.new
    @deck.attributes = deck_params
  end

  def load_decks
    @decks ||= deck_scope
      .ordered
      .to_a
  end

  def deck_scope
    Deck.all
  end

  def load_deck
    @deck = deck_scope.find(params[:id])
  end

  def deck_params
    params.require(:deck).permit(:title, :topic_id)
  rescue ActionController::ParameterMissing
    {}
  end
end
