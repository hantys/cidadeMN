class CausesController < ApplicationController
  before_action :set_cause, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:my_causes, :new, :edit, :create, :update, :destroy]
  # GET /causes
  # GET /causes.json
  def index
    @causes = Cause.page(params[:page]).per(50)
  end

  def my_causes
    @causes = current_user.causes.page(params[:page]).per(50)
    render :index
  end

  def find_causes
    if params[:category] == '0'
      @causes = Cause.all
    else
      @causes = Cause.where(category_id: params[:category])
    end

    respond_to do |format|
      format.json { render json: @causes.as_json and return }
    end
  end

  def show_cause
    @cause = Cause.find(params[:id])
    render :layout => false and return
  end

  # GET /causes/1
  # GET /causes/1.json
  def show
    @cause = Cause.find(params[:id])
  end

  # GET /causes/new
  def new
    @cause = Cause.new
  end

  # GET /causes/1/edit
  def edit
  end

  # POST /causes
  # POST /causes.json
  def create
    @cause = Cause.new(cause_params)
    @cause.user_id = current_user.id
    respond_to do |format|
      if @cause.save
        format.html { redirect_to @cause, notice: 'Cause was successfully created.' }
        format.json { render :show, status: :created, location: @cause }
      else
        format.html { render :new }
        format.json { render json: @cause.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /causes/1
  # PATCH/PUT /causes/1.json
  def update
    respond_to do |format|
      if @cause.update(cause_params)
        format.html { redirect_to @cause, notice: 'Cause was successfully updated.' }
        format.json { render :show, status: :ok, location: @cause }
      else
        format.html { render :edit }
        format.json { render json: @cause.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /causes/1
  # DELETE /causes/1.json
  def destroy
    @cause.destroy
    respond_to do |format|
      format.html { redirect_to causes_url, notice: 'Cause was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cause
      @cause = current_user.causes.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cause_params
      params.require(:cause).permit!
    end
end
