class ActiveCardsController < ApplicationController
  before_action :set_active_card, only: %i[ show edit update destroy ]

  # GET /active_cards or /active_cards.json
  def index
    @active_cards = ActiveCard.all
  end

  # GET /active_cards/1 or /active_cards/1.json
  def show
  end

  # GET /active_cards/new
  def new
    @active_card = ActiveCard.new
  end

  # GET /active_cards/1/edit
  def edit
  end

  # POST /active_cards or /active_cards.json
  def create
    @active_card = ActiveCard.new(active_card_params)

    respond_to do |format|
      if @active_card.save
        format.html { redirect_to @active_card, notice: "Active card was successfully created." }
        format.json { render :show, status: :created, location: @active_card }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @active_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /active_cards/1 or /active_cards/1.json
  def update
    respond_to do |format|
      if @active_card.update(active_card_params)
        format.html { redirect_to @active_card, notice: "Active card was successfully updated." }
        format.json { render :show, status: :ok, location: @active_card }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @active_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /active_cards/1 or /active_cards/1.json
  def destroy
    @active_card.destroy!

    respond_to do |format|
      format.html { redirect_to active_cards_path, status: :see_other, notice: "Active card was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_active_card
      @active_card = ActiveCard.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def active_card_params
      params.require(:active_card).permit(:explanation, :answer, :question, :level, :last_recal)
    end
end
