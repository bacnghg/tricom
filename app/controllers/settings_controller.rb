class SettingsController < ApplicationController
  before_action :set_setting, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: :export_csv

  def new
    @shains = Shainmaster.all
    @settings = Setting.new
    respond_with(@settings)
  end

  def index
    @shains = Shainmaster.all
    @setting = Setting.all
  end

  def setting
    session[:return_to] = request.referer
    @shains = Shainmaster.all
    @setting = Setting.where(社員番号: session[:user]).first
    if @setting.nil?
      @setting = Setting.new(社員番号: session[:user])
      @setting.save
    end
  end

  def show
    @shains = Shainmaster.all
    respond_with(@setting)
  end

  def edit
    @shainna = Shainmaster.find_by(社員番号: @setting.社員番号).氏名
    respond_with(@setting)
  end

  def create
    @setting = Setting.new(setting_params)
    @setting.save
    respond_with(@setting)
  end

  def update
    case params[:commit]

      when (t 'helpers.submit.setting')
        notice = t "app.flash.update_success" if @setting.update(setting_params)
        #redirect_to :back, notice: notice
        redirect_to(session[:return_to])
      when (t 'helpers.submit.update')
        flash[:notice] = t "app.flash.update_success" if @setting.update(setting_params)
        respond_with(@setting, location: settings_url)
    end

  end

  def destroy
    @shains = Shainmaster.all
    @setting.destroy
    respond_with(@setting)
  end

  def import
    if params[:file].nil?
      flash[:alert] = t "app.flash.file_nil"
      redirect_to settings_path
    elsif File.extname(params[:file].original_filename) != ".csv"
      flash[:danger] = t "app.flash.file_format_invalid"
      redirect_to settings_path
    else
      begin
        Setting.transaction do
          Setting.delete_all
          Setting.reset_pk_sequence
          Setting.import(params[:file])
          notice = t 'app.flash.import_csv'
          redirect_to :back, notice: notice
        end
      rescue => err
        flash[:danger] = err.to_s
        redirect_to settings_path
      end
    end
  end

  def export_csv
    @settings = Setting.all
    respond_to do |format|
      format.html
      format.csv { send_data @settings.to_csv, filename: "Setting.csv" }
    end
  end

  private
    def set_setting
      @setting = Setting.find(params[:id])
    end

    def setting_params
      params.require(:setting).permit :社員番号, :scrolltime, :local, :select_holiday_vn, :turning_data
    end
end
