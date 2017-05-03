class FunnelsController < ApplicationController
  def index
    start_date = params[:start_date] || Date.today - 1.month
    end_date   = params[:end_date]   || Date.today
    @funnel = get_funnel start_date, end_date

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

  def get_funnel(start_date, end_date)
    h = {}
    h['2014-12-01-2014-12-07'] = {'applied' => 5, 'hired' => 1}
    h['2014-11-01-2014-11-07'] = {'applied' => 1, 'rejected' => 2}
    h
  end
end
