class DecksController < ApplicationController
  def index
    @decks = Deck.all
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
    @deck.destroy!

    respond_to do |format|
      format.html { redirect_to decks_path, status: :see_other, notice: "Deck was successfully destroyed." }
      format.json { head :no_content }
    end
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
    params.require(:deck).permit(:title)
  rescue ActionController::ParameterMissing
    {}
  end
end
