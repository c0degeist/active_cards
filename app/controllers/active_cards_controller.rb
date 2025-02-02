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
      flash[:success] = "#{@active_card} erfolgreich erstellt"
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
      flash[:success] = "#{@active_card} erfolgreich gespeichert."
      redirect_to @active_card
    else
      flash[:error] = "ActiveCard konnte nicht gespeichert werden"
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /active_cards/1 or /active_cards/1.json
  def destroy
    load_active_card
    if @active_card.destroy
      flash[:success] = "#{@active_card} wurde gelöscht."
      redirect_to action: :index
    else
      flash[:error] = "#{@active_card} konnte nicht gelöscht werden."
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
