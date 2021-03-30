# frozen_string_literal: true

require 'csv'

class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action -> { redirect_to_root_unless_user(:can_admin_results?) }, except: [:all_voters, :leader_senior_voters]
  before_action -> { redirect_to_root_unless_user(:can_see_eligible_voters?) }, only: [:all_voters, :leader_senior_voters]

  before_action :compute_navbar_data
  def compute_navbar_data
    @pending_avatars_count = User.where.not(pending_avatar: nil).count
    @pending_media_count = CompetitionMedium.pending.count
  end

  def index
  end

  def merge_people
    @merge_people = MergePeople.new
  end

  def do_merge_people
    merge_params = params.require(:merge_people).permit(:person1_wca_id, :person2_wca_id)
    @merge_people = MergePeople.new(merge_params)
    if @merge_people.do_merge
      flash.now[:success] = "Successfully merged #{@merge_people.person2_wca_id} into #{@merge_people.person1_wca_id}!"
      @merge_people = MergePeople.new
    else
      flash.now[:danger] = "Error merging"
    end
    render 'merge_people'
  end

  def add_new_result
    @add_new_result = AddNewResult.new
  end

  def do_add_new_result
    add_new_result_params = params.require(:add_new_result).permit(:is_new_competitor, :competitor_id, :name, :country_id, :dob, :gender, :semi_id, :competition_id, :event_id, :round_id, :value1, :value2, :value3, :value4, :value5)
    @add_new_result = AddNewResult.new(add_new_result_params)

    add_new_result_reponse = @add_new_result.do_add_new_result
    if add_new_result_reponse && !add_new_result_reponse[:error]
      # show success message with helpful reminders of remaining steps after a successful insert of a new result
      flash.now[:success] = "Successfully added new result for #{view_context.link_to(add_new_result_reponse[:wca_id], person_path(add_new_result_reponse[:wca_id]))}! 
        Please make sure to: 
        1. #{view_context.link_to("Check Records", "/results/admin/check_regional_record_markers.php?competitionId=#{@add_new_result.competition_id}&show=Show")}. 
        2. #{view_context.link_to("Check Competition Validators", competition_admin_check_existing_results_path(@add_new_result.competition_id))}.
        3. #{view_context.link_to("Run Compute Auxillery Data", admin_compute_auxiliary_data_path)}.
        #{@add_new_result.is_new_competitor.to_i == 1 ? "4. Notify WFC of the additional competitor.": ""}
        ".html_safe
      @add_new_result = AddNewResult.new
    else
      flash.now[:danger] = add_new_result_reponse[:error] || "Error adding new result"
    end

    render 'add_new_result'
  end

  def new_results
    @competition = competition_from_params
    @upload_json = UploadJson.new
    @results_validator = ResultsValidators::CompetitionsResultsValidator.create_full_validation
    @results_validator.validate(@competition.id)
  end

  def check_results
    @competition = competition_from_params
    # For this view, we just build an empty validator: the WRT will decide what
    # to actually run (by default all validators will be selected).
    @results_validator = ResultsValidators::CompetitionsResultsValidator.new(check_real_results: true)
  end

  def run_validators
    action_params = params.require(:results_validation).permit(:competition_ids, :validators, :apply_fixes)
    # NOTE: for now only one competition is supported, we plan to extend this
    # endpoint to support an arbitrary set of competitions (we'll need to
    # render a different view in this case).

    @competition = Competition.find(action_params[:competition_ids])
    validator_classes = action_params[:validators].split(",").map { |v| ResultsValidators::Utils.validator_class_from_name(v) }.compact
    apply_fixes = ActiveModel::Type::Boolean.new.cast(action_params[:apply_fixes])
    @results_validator = ResultsValidators::CompetitionsResultsValidator.new(check_real_results: true, validators: validator_classes, apply_fixes: apply_fixes)
    @results_validator.validate(@competition.id)
    render :check_results
  end

  def clear_results_submission
    # Just clear the "results_submitted_at" field to let the Delegate submit
    # the results again. We don't actually want to clear InboxResult and InboxPerson.
    @competition = competition_from_params

    if @competition.results_submitted? && !@competition.results_posted?
      @competition.update_attributes(results_submitted_at: nil)
      flash[:success] = "Results submission cleared."
    else
      flash[:danger] = "Could not clear the results submission. Maybe results are alredy posted, or there is no submission."
    end
    redirect_to competition_admin_upload_results_edit_path
  end

  def create_results
    @competition = competition_from_params

    # Do json analysis + insert record in db, then redirect to check inbox
    # (and delete existing record if any)
    upload_json_params = params.require(:upload_json).permit(:results_file)
    upload_json_params[:competition_id] = @competition.id
    @upload_json = UploadJson.new(upload_json_params)

    # This makes sure the json structure is valid!
    if @upload_json.import_to_inbox
      if @competition.results_submitted_at.nil?
        @competition.update!(results_submitted_at: Time.now)
      end
      flash[:success] = "JSON file has been imported."
      redirect_to competition_admin_upload_results_edit_path
    else
      @results_validator = ResultsValidators::CompetitionsResultsValidator.create_full_validation
      @results_validator.validate(@competition.id)
      render :new_results
    end
  end

  def edit_person
    @person = Person.current.find_by(wca_id: params[:person].try(:[], :wca_id))
    # If there isn't a person in the params, make an empty one that simple form have an object to work with.
    # Note: most of the time persons are dynamically selected using user_id picker.
    @person ||= Person.new
  end

  def update_person
    @person = Person.current.find_by(wca_id: params[:person][:wca_id])
    if @person
      person_params = params.require(:person).permit(:name, :countryId, :gender, :dob, :incorrect_wca_id_claim_count)
      case params[:method]
      when "fix"
        if @person.update_attributes(person_params)
          flash.now[:success] = "Successfully fixed #{@person.name}."
          if @person.saved_change_to_countryId?
            flash.now[:warning] = "The change you made may have affected national and continental records, be sure to run
            <a href='/results/admin/check_regional_record_markers.php'>check_regional_record_markers</a>.".html_safe
          end
        else
          flash.now[:danger] = "Error while fixing #{@person.name}."
        end
      when "update"
        if @person.update_using_sub_id(person_params)
          flash.now[:success] = "Successfully updated #{@person.name}."
        else
          flash.now[:danger] = "Error while updating #{@person.name}."
        end
      end
    else
      @person = Person.new
      flash.now[:danger] = "No person has been chosen."
    end
    render :edit_person
  end

  def person_data
    @person = Person.current.find_by!(wca_id: params[:person_wca_id])

    render json: {
      name: @person.name,
      countryId: @person.countryId,
      gender: @person.gender,
      dob: @person.dob,
      incorrect_wca_id_claim_count: @person.incorrect_wca_id_claim_count,
    }
  end

  def competition_data
    @competition = Competition.find_by!(id: params[:competition_id])

    render json: {
      name: @competition.name,
      events: @competition.events,
      competition_events: @competition.competition_events,
      rounds: @competition.rounds
    }
  end

  def compute_auxiliary_data
    @reason_not_to_run = ComputeAuxiliaryData.reason_not_to_run
  end

  def do_compute_auxiliary_data
    ComputeAuxiliaryData.perform_later unless ComputeAuxiliaryData.in_progress?
    redirect_to admin_compute_auxiliary_data_path
  end

  def all_voters
    voters User.eligible_voters, "all-wca-voters"
  end

  def leader_senior_voters
    voters User.leader_senior_voters, "leader-senior-wca-voters"
  end

  private def voters(users, filename)
    csv = CSV.generate do |line|
      users.each do |user|
        line << [user.id, user.email, user.name]
      end
    end
    send_data csv, filename: "#{filename}-#{Time.now.utc.iso8601}.csv", type: :csv
  end

  def update_statistics
    Dir.chdir('../webroot/results') { `php statistics.php update >/dev/null 2>&1 &` }
    flash[:info] = "Computation of the statistics has been started, it should take several minutes.
                    Note that you will receive no information about the outcome,
                    also please don't queue up multiple simultaneous statistics computations."
    redirect_to admin_url
  end

  private def competition_from_params
    Competition.find_by_id!(params[:competition_id])
  end
end
