class ApplicantsController < ApplicationController

  def new
    # get from rails cache if session has email else...
    # redirect to background check if persisted
    # redirect to confirmation if application complete 
    @applicant = Applicant.new
  end

  def create
    @applicant = Applicant.new(applicant_params.merge(workflow_state: 'applied'))
    if @applicant.save
      redirect_to background_check_applicant_path(@applicant)
    else
      render :new
    end
  end

  def background_check
    @applicant = Applicant.find(params[:id])
  end

  def update
    @applicant = Applicant.find(params[:id])
    if @applicant.update_attributes(applicant_params) && @applicant.permits_background_check
      render :confirmation
    else
      @applicant.errors.add(:permits_background_check, 'we need your permission')
      render :background_check
    end
  end

  def show
    # your code here
  end

  private

  def applicant_params
    params.require(:applicant).permit(:email, :first_name, :last_name, :phone, :phone_type, :region, :permits_background_check)
  end
end
