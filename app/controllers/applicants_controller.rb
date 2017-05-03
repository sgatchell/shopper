class ApplicantsController < ApplicationController
  def new
    @applicant = Applicant.new
    
  end

  def create
    @applicant = Applicant.new(applicant_params.merge(workflow_state: 'applied'))
    if @applicant.save
      render text: 'good work!'
    else
      ap @applicant.errors.full_messages
      render :new
    end
  end

  def update
    # your code here
  end

  def show
    # your code here
  end

  def applicant_params
    params.require(:applicant).permit(:email, :first_name, :last_name, :phone, :phone_type, :region)
  end
end
