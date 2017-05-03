class FunnelsController < ApplicationController
  def index
    start_date = params[:start_date] || Date.today - 1.month
    end_date   = params[:end_date]   || Date.tomorrow
    @funnel = make_funnel(start_date, end_date)

    respond_to do |format|
      format.html { @chart_funnel = formatted_funnel }
      format.json { render json: @funnel }
    end
  end

  private

  # generates a formatted version of the funnel for display in d3
  def formatted_funnel
    formatted = Hash.new { |h, k| h[k] = [] }

    @funnel.each do |date, state_counts|
      state_counts.each do |state, count|
        formatted[state] << {label: date, value: count}
      end
    end

    formatted.map do |k, v|
      {
        key: k.humanize,
        values: v
      }
    end
  end

  def make_funnel(start_date, end_date)
    funnel = {}
    # assumes Applicant.created_at can represent the date applicant applied 
    by_weeks = Applicant.where('created_at >= ? AND created_at <= ?', start_date, end_date)
      .select('created_at, workflow_state, COUNT(workflow_state) AS workflow_state_count, strftime("%Y%W", created_at) as week')
      .group('week, workflow_state')
    by_weeks.group_by(&:week).values.each do |counts|

      date_in_week = counts.sample.created_at
      monday = date_in_week - (date_in_week.strftime("%w").to_i - 1).days
      sunday = monday + 6.days
      week_range = "#{monday.strftime '%F'}-#{sunday.strftime '%F'}"
      
      counts_hash = {}
      counts.each {|c| counts_hash[c.workflow_state] = c.workflow_state_count}
      funnel[week_range] = counts_hash
    end

    funnel
  end
end
