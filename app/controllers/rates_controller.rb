class RatesController < ApplicationController
  before_action :set_rate, only: [:show, :edit, :update, :destroy]

  # GET /rates
  # GET /rates.json
  def index
    @capitaria_rates = Rate.where(provider: 'Capitaria').order(created_at: :desc).limit(20)
    @yahoo_rates = Rate.where(provider: 'Yahoo').order(created_at: :desc).limit(20)
    @bloomberg_rates = Rate.where(provider: 'Bloomberg').order(created_at: :desc).limit(20)

    @capitaria_last_day_records = Rate.where(provider: 'Capitaria').where('created_at >= ?', 1.day.ago).count
    @yahoo_last_day_records = Rate.where(provider: 'Yahoo').where('created_at >= ?', 1.day.ago).count
    @bloomberg_last_day_records = Rate.where(provider: 'Bloomberg').where('created_at >= ?', 1.day.ago).count
  end

  # GET /rate/usdclp
  def last_usdclp
    index = -1
    found = false
    while !found
      @last_rate = Rate.all[index]
      if @last_rate.usdclp == 0.0
        index = index - 1
      else
        found = true
      end
    end

    @last_rate = Rate.all[index]
    render json: @last_rate.usdclp
  end

  # GET /rate/gbpclp
  def last_gbpclp
    @last_rate = Rate.last
    render json: @last_rate.gbpclp
  end

  # GET /rate/eurclp
  def last_eurclp
    @last_rate = Rate.last
    render json: @last_rate.eurclp
  end

  # GET /rates/1
  # GET /rates/1.json
  def show
  end

  # GET /rates/new
  def new
    @rate = Rate.new
  end

  # GET /rates/1/edit
  def edit
  end

  # POST /rates
  # POST /rates.json
  def create
    @rate = Rate.new(rate_params)

    respond_to do |format|
      if @rate.save
        format.html { redirect_to @rate, notice: 'Rate was successfully created.' }
        format.json { render :show, status: :created, location: @rate }
      else
        format.html { render :new }
        format.json { render json: @rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rates/1
  # PATCH/PUT /rates/1.json
  def update
    respond_to do |format|
      if @rate.update(rate_params)
        format.html { redirect_to @rate, notice: 'Rate was successfully updated.' }
        format.json { render :show, status: :ok, location: @rate }
      else
        format.html { render :edit }
        format.json { render json: @rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rates/1
  # DELETE /rates/1.json
  def destroy
    @rate.destroy
    respond_to do |format|
      format.html { redirect_to rates_url, notice: 'Rate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rate
      @rate = Rate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rate_params
      params.require(:rate).permit(:provider, :usdclp, :eurclp, :gbpclp)
    end
end
