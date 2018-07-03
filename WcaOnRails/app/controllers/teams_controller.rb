# frozen_string_literal: true

class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action -> { redirect_to_root_unless_user(:can_manage_teams?) }, except: [:edit, :update]
  before_action -> { redirect_to_root_unless_user(:can_edit_team?, team_from_params) }, only: [:edit, :update]

  def index
    @teams = Team.unscoped.all
  end

  def edit
    @team = team_from_params
  end

  def update
    @team = team_from_params
    if @team.update_attributes(team_params)
      flash[:success] = "Updated team"
      redirect_to edit_team_path(@team)
    else
      render :edit
    end
  end

  private def team_params
    team_params = params.require(:team).permit(:friendly_id, :hidden, team_members_attributes: [:id, :team_id, :user_id, :start_date, :end_date, :team_leader, :_destroy]).to_h
    if team_params[:team_members_attributes]
      team_params[:team_members_attributes].each do |member|
        member.second.merge!(current_user: current_user.id)
      end
    end
    team_params
  end

  private def team_from_params
    Team.unscoped.find(params[:id])
  end
end
