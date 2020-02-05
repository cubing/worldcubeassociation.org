# frozen_string_literal: true

require "rails_helper"

RSpec.describe "competitions" do
  let(:competition) { FactoryBot.create(:competition, :with_delegate, :visible, :with_valid_schedule) }

  describe 'PATCH #update_competition' do
    context "when signed in as admin" do
      sign_in { FactoryBot.create :admin }

      it 'can confirm competition' do
        patch competition_path(competition), params: {
          'competition[name]' => competition.name,
          'competition[delegate_ids]' => competition.delegate_ids,
          'commit' => 'Confirm',
        }
        follow_redirect!
        expect(response).to be_successful

        expect(competition.reload.confirmed?).to eq true
      end

      it 'can set championship types for an unconfirmed competition' do
        expect(competition.confirmed?).to be false

        patch competition_path(competition), params: {
          competition: {
            championships_attributes: {
              "1" => { championship_type: "world" },
              "0" => { championship_type: "_Europe" },
            },
          },
        }
        follow_redirect!
        expect(response).to be_successful
        expect(competition.reload.championships.count).to eq 2
      end

      it 'can set championship types for a confirmed competition' do
        competition.update!(confirmed: true)

        patch competition_path(competition), params: {
          competition: {
            championships_attributes: {
              "1" => { championship_type: "world" },
              "0" => { championship_type: "_Europe" },
            },
          },
        }
        follow_redirect!
        expect(response).to be_successful
        expect(competition.reload.championships.count).to eq 2
      end
    end

    context "signed in as a delegate" do
      before :each do
        sign_in competition.delegates.first
        competition.update!(start_date: 5.weeks.from_now, end_date: 5.weeks.from_now)
      end

      it 'can set championship types for an unconfirmed competition' do
        expect(competition.confirmed?).to be false

        patch competition_path(competition), params: {
          competition: {
            championships_attributes: {
              "1" => { championship_type: "world" },
              "0" => { championship_type: "_Europe" },
            },
          },
        }
        follow_redirect!
        expect(response).to be_successful
        expect(competition.reload.championships.count).to eq 2
      end

      it 'cannot set championship types for a confirmed competition' do
        competition.update!(confirmed: true)

        patch competition_path(competition), params: {
          competition: {
            championships_attributes: {
              "1" => { championship_type: "world" },
              "0" => { championship_type: "_Europe" },
            },
          },
        }
        follow_redirect!
        expect(response).to be_successful
        expect(competition.reload.championships.count).to eq 0
      end
    end
  end
end
