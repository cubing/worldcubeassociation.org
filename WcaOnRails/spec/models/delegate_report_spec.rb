# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DelegateReport do
  it "factory makes a valid delegate report" do
    dr = FactoryBot.create :delegate_report
    expect(dr).to be_valid
  end

  it "validates urls" do
    valid_urls = [
      'http://www.google.com',
      'https://www.google.com',
    ]
    invalid_urls = [
      'https://',
      'http://',
      'http://www.google.com ',
      ' http://www.google.com',
      'http://www. google.com',
      'foo.com',
      "bar",
    ]

    valid_urls.each do |valid_url|
      dr = FactoryBot.build :delegate_report, schedule_url: valid_url, discussion_url: valid_url
      expect(dr).to be_valid
    end

    invalid_urls.each do |invalid_url|
      dr = FactoryBot.build :delegate_report, schedule_url: invalid_url, discussion_url: nil
      expect(dr).to be_invalid

      dr = FactoryBot.build :delegate_report, schedule_url: nil, discussion_url: invalid_url
      expect(dr).to be_invalid
    end
  end

  it "schedule_url is not required when posted" do
    dr = FactoryBot.build :delegate_report, schedule_url: nil
    expect(dr).to be_valid

    dr.posted = true
    expect(dr).to be_valid

    dr.schedule_url = "http://www.google.com"
    expect(dr).to be_valid
  end

  it "discussion_url is set on creation" do
    dr = FactoryBot.create :delegate_report
    expect(dr.discussion_url).to eq "https://groups.google.com/forum/#!topicsearchin/wca-delegates/" + URI.encode_www_form_component(dr.competition.name)
  end

  context "can_view_delegate_report?" do
    let(:other_delegate) { FactoryBot.create :delegate }
    let(:board_member) { FactoryBot.create :board_member }

    context "past competition" do
      let(:competition) { FactoryBot.create :competition, :with_delegate, starts: 1.week.ago }
      let(:delegate) { competition.delegates.first }

      it "cannot view delegate report with unposted report" do
        expect(other_delegate.can_view_delegate_report?(competition.delegate_report)).to eq false
      end

      it "can view delegate report with posted report" do
        competition.delegate_report.update_attributes!(schedule_url: "http://example.com", posted: true)

        expect(other_delegate.can_view_delegate_report?(competition.delegate_report)).to eq true
      end

      it "can view own delegate report for unposted report" do
        expect(delegate.can_view_delegate_report?(competition.delegate_report)).to eq true
      end

      it "board member can view delegate report for unposted report" do
        expect(board_member.can_view_delegate_report?(competition.delegate_report)).to eq true
      end
    end

    context "upcoming competition" do
      let(:competition) { FactoryBot.create :competition, :with_delegate, starts: 1.week.from_now }
      let(:delegate) { competition.delegates.first }

      it "cannot view delegate report with unposted report" do
        expect(other_delegate.can_view_delegate_report?(competition.delegate_report)).to eq false
      end

      it "can view own delegate report for unposted report" do
        expect(delegate.can_view_delegate_report?(competition.delegate_report)).to eq true
      end

      it "board member can view delegate report for unposted report" do
        expect(board_member.can_view_delegate_report?(competition.delegate_report)).to eq true
      end
    end
  end
end
