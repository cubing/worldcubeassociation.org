# frozen_string_literal: true
class Result < ActiveRecord::Base
  self.table_name = "Results"

  belongs_to :competition, foreign_key: :competitionId
  belongs_to :person, -> { current }, primary_key: :wca_id, foreign_key: :personId
  belongs_to :round, foreign_key: :roundId
  belongs_to :event, foreign_key: :eventId

  scope :podium, -> { joins(:round).merge(Round.final_rounds).where(pos: [1..3]).where("best > 0") }
  scope :winners, -> { joins(:round, :event).merge(Round.final_rounds).where("pos = 1 and best > 0").order("Events.rank") }

  def to_s(field)
    SolveTime.new(eventId, field, send(field)).clock_format
  end

  def self.search_by_person(wca_id, params: {})
    results = Result.select('pos', 'personId', 'competitionId', 'eventId', 'roundId', 'formatId', 'value1', 'value2', 'value3', 'value4', 'value5', 'best', 'average', 'regionalSingleRecord', 'regionalAverageRecord')
    .where(personId: wca_id)

    if params[:competitionId].present?
      competition = Competition.find_by_id(params[:competitionId])
      if !competition
        raise WcaExceptions::BadApiParameter, "Competition does not exist: '#{params[:competitionId]}'"
      end
      results = results.where(competitionId: competition.id)
    end

    if params[:eventId].present?
      results = results.where(eventId: params[:eventId])
    end

    if params[:roundId].present?
      results = results.where(roundId: params[:roundId])
    end

    results.group_by(&:eventId)
  end

  def self.search_by_competition(competitionId, params: {})
    results = Result.where(competitionId: competitionId)

    if params[:wca_id].present?
      results = results.where(personId: params[:wca_id])
    end

    if params[:eventId].present?
      results = results.where(eventId: params[:eventId])
    end

    events = results.distinct.pluck(:eventId)

    rounds = events.map{ |e| {
      eventId: e,
      rounds: results.where(eventId: e).distinct.pluck(:roundId).map{ |r| {
          roundId: r,
          formatId: results.where(eventId: e, roundId: r).distinct.pluck(:formatId)[0],
          results: results.select(:pos, :personId, :personName, :countryId, :best, :average, :value1, :value2, :value3, :value4, :value5).where(eventId: e, roundId: r).map{ |result| {
            personId: result.personId,
            personName: result.personName,
            results: [result.value1, result.value2, result.value3, result.value4, result.value5],
            best: result.best,
            average: result.average
          }}
        }
      }
    }}

    rounds
  end
end
