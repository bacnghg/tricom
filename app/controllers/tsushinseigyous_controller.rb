class TsushinseigyousController < ApplicationController
  before_action :require_user!
  respond_to :html, :js

  def index
    @tsushinseigyous = Tsushinseigyou.all
    respond_with(@tsushinseigyous)
  end

  def create
    @tsushinseigyou = Tsushinseigyou.new(tsushinseigyou_params)
    @tsushinseigyou.save
    respond_with(@tsushinseigyou, location: tsushinseigyous_url)
  end

  def update
    @tsushinseigyou = Tsushinseigyou.find_by(社員番号: tsushinseigyou_params[:社員番号])
    @tsushinseigyou.update(tsushinseigyou_params)
    respond_with(@tsushinseigyou, location: tsushinseigyous_url)
  end

  def destroy
    if params[:ids]
      Tsushinseigyou.where(id: params[:ids]).destroy_all
      data = { destroy_success: 'success' }
      respond_to do |format|
        format.json { render json: data }
      end
    else
      @tsushinseigyou = Tsushinseigyou.find_by_id(params[:id])
      @tsushinseigyou.destroy if @tsushinseigyou
      respond_with(@tsushinseigyou)
    end
  end

  def import
    if params[:file].nil?
      flash[:alert] = t 'app.flash.file_nil'
      redirect_to tsushinseigyous_path
    elsif File.extname(params[:file].original_filename) != '.csv'
      flash[:danger] = t 'app.flash.file_format_invalid'
      redirect_to tsushinseigyous_path
    else
      begin
        Tsushinseigyou.transaction do
          Tsushinseigyou.delete_all
          Tsushinseigyou.reset_pk_sequence
          Tsushinseigyou.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to tsushinseigyous_path
      end
    end
  end

  def export_csv
    @tsushinseigyous = Tsushinseigyou.all
    respond_to do |format|
      format.csv { send_data @tsushinseigyous.to_csv, filename: '通信制御マスタ.csv' }
    end
  end

  private

  def tsushinseigyou_params
    params.require(:tsushinseigyou).permit(:社員番号, :メール, :送信許可区分, :id)
  end

end
