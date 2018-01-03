# frozen_string_literal: true

class Api::V0::CompetitionsController < Api::V0::ApiController
  def index
    managed_by_user = nil
    if params[:managed_by_me].present?
      require_scope!("manage_competitions")
      managed_by_user = current_api_user
    end

    competitions = Competition.search(params[:q], params: params, managed_by_user: managed_by_user)
    competitions = competitions.includes(:delegates, :organizers)

    paginate json: competitions
  end

  def show
    competition = competition_from_params
    render json: competition
  end

  def show_wcif
    # This is all the associations we may need for the WCIF!
    includes_associations = [
      {
        registrations: [{ user: { person: [:ranksSingle, :ranksAverage] } },
                        :events],
      },
      :delegates,
      :organizers,
    ]
    competition = competition_from_params(includes_associations)
    require_can_manage!(competition)

    render json: competition.to_wcif
  end

  def update_events_from_wcif
    competition = competition_from_params
    require_can_manage!(competition)
    wcif_events = params["_json"].map { |wcif_event| wcif_event.permit!.to_h }
    competition.set_wcif_events!(wcif_events)
    render json: {
      status: "Successfully saved WCIF events",
    }
  rescue ActiveRecord::RecordInvalid => e
    render status: 400, json: {
      status: "Error while saving WCIF events",
      error: e,
    }
  rescue JSON::Schema::ValidationError => e
    render status: 400, json: {
      status: "Error while saving WCIF events",
      error: e.message,
    }
  rescue WcaExceptions::ApiException => e
    render status: e.status, json: { error: e.to_s }
  end

  private def competition_from_params(associations = {})
    id = params[:competition_id] || params[:id]
    base_model = associations.any? ? Competition.includes(associations) : Competition
    competition = base_model.find_by_id(id)

    # If this competition exists, but is not publicly visible, then only show it
    # to the user if they are able to manage the competition.
    if competition && !competition.showAtAll && !can_manage?(competition)
      competition = nil
    end

    raise WcaExceptions::NotFound.new("Competition with id #{id} not found") unless competition
    competition
  end

  private def can_manage?(competition)
    current_api_user&.can_manage_competition?(competition) && doorkeeper_token.scopes.exists?("manage_competitions")
  end

  private def require_scope!(scope)
    raise WcaExceptions::MustLogIn.new unless current_api_user
    raise WcaExceptions::BadApiParameter.new("Missing required scope '#{scope}'") unless doorkeeper_token.scopes.include?(scope)
  end

  def require_can_manage!(competition)
    raise WcaExceptions::MustLogIn.new unless current_api_user
    raise WcaExceptions::NotPermitted.new("Not authorized to manage competition") unless can_manage?(competition)
  end
end
