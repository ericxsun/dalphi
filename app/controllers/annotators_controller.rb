class AnnotatorsController < ApplicationController
  before_action :set_annotator, only: [:edit, :update, :destroy]
  before_action :set_project

  # GET /annotators
  def index
    @annotator = Annotator.new
    objects_per_page = Rails.configuration.x.dalphi['paginated-objects-per-page']['annotators']
    where = {}
    @annotators = Annotator.all
                           .order(name: :asc)
                           .paginate(
                             page: params[:page],
                             per_page: objects_per_page
                           )
  end

  # POST /annotators
  def create
    @annotator = Annotator.new(annotator_params)
    @annotator.password = SecureRandom.hex unless @annotator.password.present?
    if @annotator.save
      redirect_to annotators_path, notice: I18n.t('annotators.action.create.success')
    else
      flash.now[:error] = I18n.t('simple_form.error_notification.default_message')
      render :new
    end
  end

  # GET /annotators/1/edit
  def edit
  end

  # PATCH /annotators/1
  def update
    if @annotator.update(annotator_params)
      redirect_to annotators_path, notice: I18n.t('annotators.action.update.success')
    else
      flash.now[:error] = I18n.t('simple_form.error_notification.default_message')
      render :edit
    end
  end

  # DELETE /annotators/1
  def destroy
    @annotator.destroy
    redirect_to annotators_path, notice: I18n.t('annotators.action.destroy.success')
  end

  private

  def set_annotator
    @annotator = Annotator.find(params[:id])
  end

  def set_project
    @project = Project.find(params[:project_id]) if params[:project_id]
  end

  def annotator_params
    tmp_params = params.require(:annotator).permit(
      :name,
      :email,
      :password
    )
    tmp_params.except!(:password) unless params[:annotator][:password].present?
    tmp_params
  end
end
