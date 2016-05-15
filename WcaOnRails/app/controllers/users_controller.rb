class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:search, :select_nearby_delegate]

  def self.WCA_TEAMS
    %w(software results wdc wrc)
  end

  def index
    unless current_user && current_user.can_edit_users?
      flash[:danger] = "You cannot edit users"
      redirect_to root_url
    end
    respond_to do |format|
      format.html { }
      format.json do
        @users = User
        if params[:search]
          @users = @users.where("name LIKE :input OR wca_id LIKE :input OR email LIKE :input", { input: "%#{params[:search]}%" })
        end
        if params[:sort]
          @users = @users.order(params[:sort] => params[:order])
        end
        render json: {
          total: @users.count,
          rows: @users.limit(params[:limit]).offset(params[:offset]).map do |user|
            {
              wca_id: user.wca_id ? view_context.link_to(user.wca_id, "/results/p.php?i=#{user.wca_id}") : "",
              name: user.name,
              email: user.email,
              edit: view_context.link_to("Edit", edit_user_path(user)),
            }
          end,
        }
      end
    end
  end

  private def user_to_edit
    User.includes(:current_teams).find_by_id(params[:id] || current_user.id)
  end

  def edit
    params[:section] ||= "general"

    @user = user_to_edit
    redirect_if_cannot_edit_user(@user) and return
  end

  def claim_wca_id
    @user = current_user
  end

  def select_nearby_delegate
    @user = current_user || User.new
    user_params = params.require(:user).permit(:unconfirmed_wca_id, :delegate_id_to_handle_wca_id_claim, :dob_verification)
    @user.assign_attributes(user_params)
    render partial: 'select_nearby_delegate'
  end

  def edit_avatar_thumbnail
    @user = user_to_edit
    redirect_if_cannot_edit_user(@user) and return
  end

  def edit_pending_avatar_thumbnail
    @user = user_to_edit
    @pending_avatar = true
    redirect_if_cannot_edit_user(@user) and return
    render :edit_avatar_thumbnail
  end

  def update
    @user = user_to_edit
    @user.current_user = current_user
    redirect_if_cannot_edit_user(@user) and return

    old_confirmation_sent_at = @user.confirmation_sent_at
    dangerous_change = current_user == @user && [:password, :password_confirmation, :email].any? { |attribute| user_params.key? attribute }
    if dangerous_change ? @user.update_with_password(user_params) : @user.update_attributes(user_params)
      if current_user == @user
        # Sign in the user by passing validation in case their password changed
        sign_in @user, bypass: true
      end
      flash[:success] = if @user.confirmation_sent_at != old_confirmation_sent_at
                          I18n.t('successes.messages.account_updated_confirm', email: @user.unconfirmed_email)
                        else
                          I18n.t('successes.messages.account_updated')
                        end
      if @user.claiming_wca_id
        flash[:success] = I18n.t('successes.messages.wca_id_claimed',
                                 wca_id: @user.unconfirmed_wca_id,
                                 user: @user.delegate_to_handle_wca_id_claim.name)
        WcaIdClaimMailer.notify_delegate_of_wca_id_claim(@user).deliver_now
        redirect_to profile_claim_wca_id_path
      else
        redirect_to edit_user_url(@user, params.permit(:section))
      end
    elsif @user.claiming_wca_id
      render :claim_wca_id
    else
      render :edit
    end
  end

  private def redirect_if_cannot_edit_user(user)
    unless current_user && (current_user.can_edit_users? || current_user == user)
      flash[:danger] = "You cannot edit this user"
      redirect_to root_url
      return true
    end
    return false
  end

  private def user_params
    user_params = params.require(:user).permit(current_user.editable_fields_of_user(user_to_edit).to_a)
    if user_params.key?(:delegate_status) && !User.delegate_status_allows_senior_delegate(user_params[:delegate_status])
      user_params["senior_delegate_id"] = nil
    end
    if user_params.key?(:wca_id)
      user_params[:wca_id] = user_params[:wca_id].upcase
    end
    user_params
  end
end
