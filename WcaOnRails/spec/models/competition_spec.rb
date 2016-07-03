require 'rails_helper'

RSpec.describe Competition do
  it "defines a valid competition" do
    competition = FactoryGirl.build :competition, name: "Foo: Test - 2015"
    expect(competition).to be_valid
    expect(competition.id).to eq "FooTest2015"
    expect(competition.name).to eq "Foo: Test - 2015"
    expect(competition.cellName).to eq "Foo: Test - 2015"
  end

  it "rejects invalid names" do
    [
      "foo (Test) - 2015",
      "Poly^3 2016",
      "HOOAH! SMA 2015",
      "Campeonato de Cubos Mágicos de São Carlos/SP 2013",
      "Moldavian Nationals – Winter 2016",
      "PingSkills Cubing Classic, 2016",
    ].each do |name|
      expect(FactoryGirl.build(:competition, name: name)).to be_invalid
    end
  end

  it "handles missing start/end_date" do
    competition = FactoryGirl.build :competition, start_date: nil, end_date: nil
    competition2 = FactoryGirl.build :competition, start_date: nil, end_date: nil
    expect(competition.is_over?).to be false
    expect(competition.started?).to be false
    expect(competition.in_progress?).to be false
    expect(competition.dangerously_close_to?(competition2)).to be false
  end

  it "requires that registration_open be before registration_close" do
    competition = FactoryGirl.build :competition, name: "Foo Test 2015", registration_open: 1.week.ago, registration_close: 2.weeks.ago, use_wca_registration: true
    expect(competition).to be_invalid
    expect(competition.errors.messages[:registration_close]).to eq ["registration close must be after registration open"]
  end

  it "requires registration_open if use_wca_registration" do
    competition = FactoryGirl.build :competition, name: "Foo Test 2015", registration_open: nil, registration_close: 2.weeks.ago, use_wca_registration: true
    expect(competition).to be_invalid
    expect(competition.errors.messages[:registration_open]).to eq ["required"]
  end

  it "requires registration_close if use_wca_registration" do
    competition = FactoryGirl.build :competition, name: "Foo Test 2015", registration_open: 1.week.ago, registration_close: nil, use_wca_registration: true
    expect(competition).to be_invalid
    expect(competition.errors.messages[:registration_close]).to eq ["required"]
  end

  it "truncates name as necessary to produce id and cellName" do
    competition = FactoryGirl.build :competition, name: "Alexander and the Terrible Horrible No Good 2015"
    expect(competition).to be_valid
    expect(competition.id).to eq "AlexanderandtheTerribleHorri2015"
    expect(competition.name).to eq "Alexander and the Terrible Horrible No Good 2015"
    expect(competition.friendly_id).to eq "AlexanderandtheTerribleHorri2015"
    expect(competition.cellName).to eq "Alexander and the Terrib... 2015"
  end

  it "saves without losing data" do
    competition = FactoryGirl.create :competition
    json_data = competition.as_json
    competition.save
    expect(competition.as_json).to eq json_data
  end

  it "requires that name end in a year" do
    competition = FactoryGirl.build :competition, name: "Name without year"
    expect(competition).to be_invalid
    expect(competition.errors.messages[:name]).to eq ["must end with a year and must contain only alphnumeric characters, dashes(-), ampersands(&), periods(.), colons(:), apostrophes('), and spaces( )"]
  end

  it "requires that cellName end in a year" do
    competition = FactoryGirl.build :competition, cellName: "Name no year"
    expect(competition).to be_invalid
  end

  it "populates year, month, day, endMonth, endDay" do
    competition = FactoryGirl.create :competition
    competition.start_date = "1987-11-06"
    competition.end_date = "1987-12-07"
    competition.save!
    expect(competition.year).to eq 1987
    expect(competition.month).to eq 11
    expect(competition.day).to eq 6
    expect(competition.endMonth).to eq 12
    expect(competition.endDay).to eq 7
  end

  describe "validates date formats" do
    let(:competition) do
      c = FactoryGirl.create :competition
      # Clear any instance variables the Competition may have from being created.
      Competition.find(c.id)
    end

    it "start_date" do
      competition.start_date = "1987-12-04f"
      expect(competition).to be_invalid
      expect(competition.errors.messages[:start_date]).to eq ["invalid"]
    end

    it "end_date" do
      competition.end_date = "1987-12-04f"
      expect(competition).to be_invalid
      expect(competition.errors.messages[:end_date]).to eq ["invalid"]
    end
  end

  it "requires that both dates are empty or both are valid" do
    competition = FactoryGirl.create :competition
    competition.start_date = "1987-12-04"
    expect(competition).to be_invalid

    competition.end_date = "1987-12-05"
    expect(competition).to be_valid
  end

  it "requires that the start is before the end" do
    competition = FactoryGirl.create :competition
    competition.start_date = "1987-12-06"
    competition.end_date = "1987-12-05"
    expect(competition).to be_invalid
  end

  it "requires that competition starts and ends in the same year" do
    competition = FactoryGirl.create :competition
    competition.start_date = "1987-12-06"
    competition.end_date = "1988-12-07"
    expect(competition).to be_invalid
  end

  it "requires competition name is not greater than 50 characters" do
    competition = FactoryGirl.build :competition, name: "A really long competition name that is greater than 50 characters 2016"
    expect(competition).to be_invalid
    expect(competition.errors.messages[:name]).to eq ["is too long (maximum is 50 characters)"]
  end

  context "#user_should_post_delegate_report?" do
    it "warns for unposted reports" do
      competition = FactoryGirl.create :competition, :visible, :with_delegate, starts: 2.days.ago
      delegate = competition.delegates.first
      expect(competition.user_should_post_delegate_report?(delegate)).to eq true
    end

    it "does not warn for posted reports" do
      competition = FactoryGirl.create :competition, :visible, :with_delegate, starts: 2.days.ago
      competition.delegate_report.update_attributes!(schedule_url: "http://example.com", posted: true)
      delegate = competition.delegates.first
      expect(competition.user_should_post_delegate_report?(delegate)).to eq false
    end

    it "does not warn for upcoming competitions" do
      competition = FactoryGirl.create :competition, :visible, :with_delegate, starts: 1.days.from_now
      delegate = competition.delegates.first
      expect(competition.user_should_post_delegate_report?(delegate)).to eq false
    end

    it "does not warn board members" do
      competition = FactoryGirl.create :competition, :visible, :with_delegate, starts: 2.days.ago
      board_member = FactoryGirl.create :board_member
      expect(competition.user_should_post_delegate_report?(board_member)).to eq false
    end
  end

  context "warnings_for" do
    it "warns if competition name is greater than 32 characters and it's not publicly visible" do
      competition = FactoryGirl.build :competition, name: "A really long competition name 2016", showAtAll: false
      expect(competition).to be_valid
      expect(competition.warnings_for(nil)[:name]).to eq "The competition name is longer than 32 characters. We prefer shorter ones and we will be glad if you change it."
    end

    it "does not warn about name greater than 32 when competition is publicly visible" do
      competition = FactoryGirl.build :competition, :confirmed, :visible, name: "A really long competition name 2016"
      expect(competition).to be_valid
      expect(competition.warnings_for(nil)[:name]).to eq nil
    end

    it "warns if competition is not visible" do
      competition = FactoryGirl.build :competition, showAtAll: false
      expect(competition).to be_valid
      expect(competition.warnings_for(nil)[:invisible]).to eq "This competition is not visible to the public."
    end
  end

  context "info_for" do
    it "displays info if competition is finished but results aren't posted" do
      competition = FactoryGirl.build :competition, starts: 1.month.ago
      expect(competition).to be_valid
      expect(competition.is_over?).to be true
      expect(competition.results_posted?).to be false
      expect(competition.info_for(nil)[:upload_results]).to eq "This competition is over, we are working to upload the results as soon as possible!"
    end

    it "displays info if competition is in progress" do
      competition = FactoryGirl.build :competition, starts: Date.today
      expect(competition).to be_valid
      expect(competition.in_progress?).to be true
      expect(competition.info_for(nil)[:in_progress]).to eq "This competition is ongoing. Come back after #{competition.end_date.to_formatted_s(:long)} to see the results!"

      competition.results_posted_at = Time.now
      expect(competition.in_progress?).to be false
      expect(competition.info_for(nil)[:in_progress]).to eq nil
    end
  end

  it "knows the calendar" do
    competition = FactoryGirl.create :competition
    competition.start_date = "1987-0-04"
    competition.end_date = "1987-12-05"
    expect(competition).to be_invalid

    competition.start_date = "1987-4-04"
    competition.end_date = "1987-33-05"
    expect(competition).to be_invalid
  end

  it "gracefully handles multiyear competitions" do
    competition = FactoryGirl.create :competition
    competition.start_date = "1987-11-06"
    competition.end_date = "1988-12-07"
    competition.save
    expect(competition).to be_invalid
    expect(competition.end_date).to eq Date.parse("1988-12-07")
  end

  it "ignores equal signs in eventSpecs" do
    # See https://github.com/cubing/worldcubeassociation.org/issues/95
    competition = FactoryGirl.build :competition, eventSpecs: "   333=//sd    444   "
    expect(competition.events.map(&:id)).to eq %w(333 444)
  end

  it "validates event ids" do
    competition = FactoryGirl.build :competition, eventSpecs: "333 333wtf"
    expect(competition).to be_invalid
  end

  it "converts microdegrees to degrees" do
    competition = FactoryGirl.build :competition, latitude: 40, longitude: 30
    expect(competition.latitude_degrees).to eq 40/1e6
    expect(competition.longitude_degrees).to eq 30/1e6
  end

  it "converts degrees to microdegrees when saving" do
    competition = FactoryGirl.create :competition
    competition.latitude_degrees = 3.5
    competition.longitude_degrees = 4.6
    competition.save!
    expect(competition.latitude).to eq 3.5*1e6
    expect(competition.longitude).to eq 4.6*1e6
  end

  it "ensures all attributes are defined as either cloneable or uncloneable" do
    expect(Competition.column_names).to match_array(Competition::CLONEABLE_ATTRIBUTES + Competition::UNCLONEABLE_ATTRIBUTES)
  end

  describe "validates website" do
    it "likes http://foo.com" do
      competition = FactoryGirl.build :competition, website: "http://foo.com"
      expect(competition).to be_valid
    end

    it "dislikes [{foo}{http://foo.com}]" do
      competition = FactoryGirl.build :competition, website: "[{foo}{http://foo.com}]"
      expect(competition).not_to be_valid
    end

    it "dislikes htt://foo" do
      competition = FactoryGirl.build :competition, website: "htt://foo"
      expect(competition).not_to be_valid
    end
  end

  it "saves delegate_ids" do
    delegate1 = FactoryGirl.create(:delegate, name: "Daniel", email: "daniel@d.com")
    delegate2 = FactoryGirl.create(:delegate, name: "Chris", email: "chris@c.com")
    delegates = [delegate1, delegate2]
    delegate_ids = delegates.map(&:id).join(",")
    competition = FactoryGirl.create :competition, delegate_ids: delegate_ids
    expect(competition.delegates.sort_by(&:name)).to eq delegates.sort_by(&:name)
  end

  it "saves organizer_ids" do
    organizer1 = FactoryGirl.create(:user, name: "Bob", email: "bob@b.com")
    organizer2 = FactoryGirl.create(:user, name: "Jane", email: "jane@j.com")
    organizers = [organizer1, organizer2]
    organizer_ids = organizers.map(&:id).join(",")
    competition = FactoryGirl.create :competition, organizer_ids: organizer_ids
    expect(competition.organizers.sort_by(&:name)).to eq organizers.sort_by(&:name)
  end

  describe "when deleting a competition" do
    it "clears delegates" do
      delegate1 = FactoryGirl.create(:delegate)
      delegates = [delegate1]
      competition = FactoryGirl.create :competition, delegates: delegates

      cd = CompetitionDelegate.where(competition_id: competition.id, delegate_id: delegate1.id).first
      expect(cd).not_to be_nil
      competition.destroy
      expect(CompetitionDelegate.find_by_id(cd.id)).to be_nil
    end

    it "clears organizers" do
      organizer1 = FactoryGirl.create(:delegate)
      organizers = [organizer1]
      competition = FactoryGirl.create :competition, organizers: organizers

      cd = CompetitionOrganizer.where(competition_id: competition.id, organizer_id: organizer1.id).first
      expect(cd).not_to be_nil
      competition.destroy
      expect(CompetitionOrganizer.find_by_id(cd.id)).to be_nil
    end
  end

  describe "when confirming or making visible" do
    let(:competition_with_delegate) { FactoryGirl.build :competition, :with_delegate }
    let(:competition_without_delegate) { FactoryGirl.build :competition }

    [:isConfirmed, :showAtAll].each do |action|
      it "can set #{action}" do
        competition_with_delegate.public_send "#{action}=", true
        expect(competition_with_delegate).to be_valid
      end

      [:cityName, :countryId, :venue, :venueAddress, :website, :latitude, :longitude].each do |field|
        it "requires #{field} when setting #{action}" do
          competition_with_delegate.assign_attributes field => "", action => true
          expect(competition_with_delegate).not_to be_valid
        end
      end

      it "must have at least one event when setting #{action}" do
        competition_with_delegate.assign_attributes eventSpecs: "", action => true
        expect(competition_with_delegate).not_to be_valid
      end

      it "requires both dates when setting #{action}" do
        competition_with_delegate.assign_attributes start_date: "", end_date: "", action => true
        expect(competition_with_delegate).not_to be_valid
      end

      it "requires at least one delegate when setting #{action}" do
        competition_without_delegate.public_send "#{action}=", true
        expect(competition_without_delegate).not_to be_valid
      end
    end
  end

  describe "receive_registration_emails" do
    let(:competition) { FactoryGirl.create :competition }
    let(:delegate) { FactoryGirl.create :delegate }

    it "computes receiving_registration_emails? via OR" do
      expect(competition.receiving_registration_emails?(delegate.id)).to eq false

      competition.delegates << delegate
      expect(competition.receiving_registration_emails?(delegate.id)).to eq true

      cd = competition.competition_delegates.find_by_delegate_id(delegate.id)
      cd.update_column(:receive_registration_emails, false)
      expect(competition.receiving_registration_emails?(delegate.id)).to eq false

      competition.organizers << delegate
      expect(competition.receiving_registration_emails?(delegate.id)).to eq true

      co = competition.competition_organizers.find_by_organizer_id(delegate.id)
      co.update_column(:receive_registration_emails, false)
      expect(competition.receiving_registration_emails?(delegate.id)).to eq false
    end

    it "setting receive_registration_emails" do
      competition.delegates << delegate
      cd = competition.competition_delegates.find_by_delegate_id(delegate.id)
      expect(cd.receive_registration_emails).to eq true

      competition.receive_registration_emails = false
      competition.editing_user_id = delegate.id
      competition.save!
      competition.receive_registration_emails = nil
      expect(cd.reload.receive_registration_emails).to eq false

      competition.organizers << delegate
      co = competition.competition_organizers.find_by_organizer_id(delegate.id)
      expect(co.receive_registration_emails).to eq true

      competition.receive_registration_emails = false
      competition.editing_user_id = delegate.id
      competition.save!

      expect(cd.reload.receive_registration_emails).to eq false
      expect(co.reload.receive_registration_emails).to eq false
    end
  end

  describe "results" do
    let(:competition) { FactoryGirl.create :competition, eventSpecs: "333 222" }
    let(:three_by_three) { Event.find "333" }
    let(:two_by_two) { Event.find "222" }

    let(:person_one) { FactoryGirl.create :person, name: "One" }
    let(:person_two) { FactoryGirl.create :person, name: "Two" }
    let(:person_three) { FactoryGirl.create :person, name: "Three" }
    let(:person_four) { FactoryGirl.create :person, name: "Four" }

    let!(:r_333_1_first) { FactoryGirl.create :result, competition: competition, eventId: "333", roundId: "1", pos: 1, person: person_one }
    let!(:r_333_1_second) { FactoryGirl.create :result, competition: competition, eventId: "333", roundId: "1", pos: 2, person: person_two }
    let!(:r_333_1_third) { FactoryGirl.create :result, competition: competition, eventId: "333", roundId: "1", pos: 3, person: person_three }
    let!(:r_333_1_fourth) { FactoryGirl.create :result, competition: competition, eventId: "333", roundId: "1", pos: 4, person: person_four }

    let!(:r_333_f_first) { FactoryGirl.create :result, competition: competition, eventId: "333", roundId: "f", pos: 1, person: person_one }
    let!(:r_333_f_second) { FactoryGirl.create :result, competition: competition, eventId: "333", roundId: "f", pos: 2, person: person_two }
    let!(:r_333_f_third) { FactoryGirl.create :result, competition: competition, eventId: "333", roundId: "f", pos: 3, person: person_three }

    let!(:r_222_c_first) { FactoryGirl.create :result, competition: competition, eventId: "222", roundId: "c", pos: 1, person: person_one }

    it "events_with_podium_results" do
      result = competition.events_with_podium_results
      expect(result.size).to eq 2
      expect(result.first.first).to eq three_by_three
      expect(result.first.last.map(&:value1)).to eq [3000] * 3

      expect(result.last.first).to eq two_by_two
      expect(result.last.last.map(&:value1)).to eq [3000]
    end

    it "winning_results" do
      result = competition.winning_results
      expect(result.size).to eq 2
      expect(result.first.eventId).to eq "333"
      expect(result.first.best).to eq 3000
      expect(result.first.roundId).to eq "f"

      expect(result.last.eventId).to eq "222"
      expect(result.last.best).to eq 3000
      expect(result.last.roundId).to eq "c"
    end

    it "person_names_with_results" do
      result = competition.person_names_with_results
      expect(result.size).to eq 4
      expect(result.map(&:first)).to eq [person_four.name, person_one.name, person_three.name, person_two.name]
      expect(result.second.last.map(&:roundId)).to eq %w(f 1 c)

      expect(result[1][1][1].muted).to eq true
      expect(result[1][1][2].muted).to eq false

      expect(result[2][1][1].muted).to eq true
      expect(result[3][1][1].muted).to eq true
    end

    it "events_with_rounds_with_results" do
      results = competition.events_with_rounds_with_results
      expect(results.size).to eq 2
      expect(results[0].first).to eq three_by_three
      expect(results[0].second.first.first).to eq Round.find("1")
      expect(results[0].second.first.last.map(&:value1)).to eq [3000] * 4
      expect(results[0].second.first.last.map(&:eventId)).to eq ["333"] * 4
      expect(results[0].second.second.last.map(&:value1)).to eq [3000] * 3

      expect(results[1].first).to eq two_by_two
      expect(results[1].second.first.first).to eq Round.find("c")
      expect(results[1].second.first.last.map(&:value1)).to eq [3000]
    end

    it "winning_results and events_with_podium_results don't include results with DNF as best" do
      competition.results.where(eventId: "222").update_all(best: SolveTime::DNF_VALUE)
      expect(competition.winning_results.map(&:event).uniq).to eq [three_by_three]
      expect(competition.events_with_podium_results.map(&:first).uniq).to eq [three_by_three]
    end
  end
end
