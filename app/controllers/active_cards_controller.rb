class ActiveCardsController < ApplicationController

  def index
    load_active_cards
  end

  def new
    build_active_card

    if params[:deck_id]
      @active_card.deck = Deck.find(params[:deck_id])
    end
  end

  def edit
    load_active_card
    build_active_card
  end

  def create
    build_active_card

    if @active_card.save
      flash[:success] = "Card successfully created!"
      redirect_to @active_card
    else
      flash[:error] = "ActiveCard konnte nicht gespeichert werden"
      render :edit, status: :unprocessable_entity
    end
  end

  def update
    load_active_card
    build_active_card

    if @active_card.save
      flash[:success] = "Card successfully saved!"
      redirect_to @active_card
    else
      flash[:error] = "ActiveCard konnte nicht gespeichert werden"
      render :edit, status: :unprocessable_entity
    end
  end

  # TODO: Die Alert Text über alle Controller vereinheitlichen.
  # Vlt schauen wie wir das in anderen Anwendungen gemacht haben.
  def destroy
    load_active_card
    if @active_card.destroy
      flash[:success] = "Card deleted!"
      redirect_to action: :index
    else
      flash[:error] = "Card can't be deleted!"
      render :edit
    end
  end

  private

  def load_active_card
    @active_card ||= active_card_scope.find(params[:id])
  end

  def load_active_cards
    @active_cards = active_card_scope
      .ordered
      .to_a
  end

  def build_active_card
    @active_card ||= active_card_scope.new
    @active_card.attributes = active_card_params
  end

  def active_card_scope
    ActiveCard.all
  end

  def active_card_params
    params.require(:active_card).permit(:explanation, :answer, :question, :level, :last_recal, :deck_id)
  rescue ActionController::ParameterMissing
    {}
  end
end
