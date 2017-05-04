class ApplicantsController < ApplicationController

  def new
    @applicant = Applicant.find_by(email: session[:email]) || Applicant.new
    if @applicant.persisted?
      render :confirmation and return if @applicant.applied?
      redirect_to background_check_applicant_path(@applicant)
    end
  end

  def create
    @applicant = Applicant.new(applicant_params.merge(workflow_state: 'applied'))
    if @applicant.save
      session[:email] = @applicant.email
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

  private

  def applicant_params
    params.require(:applicant).permit(:email, :first_name, :last_name, :phone, :phone_type, :region, :permits_background_check)
  end
end
