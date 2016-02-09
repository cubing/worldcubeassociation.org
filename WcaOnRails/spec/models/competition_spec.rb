require 'rails_helper'

RSpec.describe Competition do
  it "defines a valid competition" do
    competition = FactoryGirl.build :competition, name: "Foo !Test- 2015"
    expect(competition).to be_valid
    expect(competition.id).to eq "FooTest2015"
    expect(competition.name).to eq "Foo !Test- 2015"
    expect(competition.cellName).to eq "Foo !Test- 2015"
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
    competition = FactoryGirl.build :competition, name: "Alexander and the Terrible, Horrible, No Good 2015"
    expect(competition).to be_valid
    expect(competition.id).to eq "AlexanderandtheTerribleHorri2015"
    expect(competition.name).to eq "Alexander and the Terrible, Horrible, No Good 2015"
    expect(competition.cellName).to eq "Alexander and the Terrible, Horrible,... 2015"
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
    expect(competition.events.map(&:id)).to eq [ "333", "444" ]
  end

  it "doesn't allow removing an event with registrations" do
    competition = FactoryGirl.create :competition, :registration_open, eventSpecs: "333 444"
    registration = FactoryGirl.create :registration, eventIds: "444", competition: competition
    competition.eventSpecs = "333"
    expect(competition.save).to eq false
    expect(competition.errors.messages[:eventSpecs]).to eq ["There are still people registered for 4x4 Cube"]
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

  describe "when changing the id of a competition" do
    let(:competition) { FactoryGirl.create(:competition, :with_delegate, :with_organizer, use_wca_registration: true) }

    it "changes the competitionId of registrations" do
      reg1 = FactoryGirl.create(:registration, competitionId: competition.id)
      competition.update_attribute(:id, "NewID2015")
      expect(reg1.reload.competitionId).to eq "NewID2015"
    end

    it "changes the competitionId of results" do
      r1 = FactoryGirl.create(:result, competitionId: competition.id)
      r2 = FactoryGirl.create(:result, competitionId: competition.id)
      competition.update_attribute(:id, "NewID2015")
      expect(r1.reload.competitionId).to eq "NewID2015"
      expect(r2.reload.competitionId).to eq "NewID2015"
    end

    it "changes the competitionId of scrambles" do
      scramble1 = FactoryGirl.create(:scramble, competitionId: competition.id)
      competition.update_attribute(:id, "NewID2015")
      expect(scramble1.reload.competitionId).to eq "NewID2015"
    end

    it "updates the competition_id of competition_delegates and competition_organizers" do
      organizer = competition.organizers.first
      delegate = competition.delegates.first

      expect(CompetitionDelegate.where(delegate_id: delegate.id).count).to eq 1
      expect(CompetitionOrganizer.where(organizer_id: organizer.id).count).to eq 1

      cd = CompetitionDelegate.find_by_delegate_id(delegate.id)
      expect(cd).not_to eq nil
      co = CompetitionOrganizer.find_by_organizer_id(organizer.id)
      expect(co).not_to eq nil

      c = Competition.find(competition.id)
      c.id = "NewID2015"
      c.save!

      expect(CompetitionDelegate.where(delegate_id: delegate.id).count).to eq 1
      expect(CompetitionOrganizer.where(organizer_id: organizer.id).count).to eq 1
      expect(CompetitionDelegate.find(cd.id).competition_id).to eq "NewID2015"
      expect(CompetitionOrganizer.find(co.id).competition_id).to eq "NewID2015"
    end
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

  describe "when confirming" do
    let(:competition) { FactoryGirl.create :competition, :with_delegate }

    it "works" do
      competition.isConfirmed = true
      expect(competition).to be_valid
    end

    [:cityName, :countryId, :venue, :venueAddress, :website, :latitude, :longitude].each do |field|
      it "requires #{field}" do
        competition.public_send "#{field}=", ""
        competition.isConfirmed = true
        expect(competition).not_to be_valid
      end
    end

    it "must have at least one event" do
      competition.eventSpecs = ""
      competition.isConfirmed = true
      expect(competition).not_to be_valid
    end

    it "requires both dates" do
      competition.start_date = ""
      competition.end_date = ""
      competition.isConfirmed = true
      expect(competition).not_to be_valid
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
end
