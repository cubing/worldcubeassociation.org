# frozen_string_literal: true

class WfcController < ApplicationController
  before_action :authenticate_user!
  before_action -> { redirect_to_root_unless_user(:can_admin_finances?) }

  def panel
  end

  def competition_export
    select_attributes = [
      :id, :name, :start_date, :end_date,
      :countryId, :announced_at, :results_posted_at,
      "count(distinct rails_persons.id) as num_competitors"
    ]
    from = params.require(:from_date)
    to = params.require(:to_date)
    @competitions=Competition
                  .select(select_attributes)
                  .includes(:delegates)
                  .joins(:competitors)
                  .group("Competitions.id")
                  .where("start_date >= ?", from)
                  .where("end_date <= ?", to)
                  .order(:start_date, :name)
  end
end
