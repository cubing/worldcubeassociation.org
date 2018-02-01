# frozen_string_literal: true

class Round < ApplicationRecord
  belongs_to :competition_event
  has_one :competition, through: :competition_event
  has_one :event, through: :competition_event
  belongs_to :format

  serialize :time_limit, TimeLimit
  validates_associated :time_limit

  serialize :cutoff, Cutoff
  validates_associated :cutoff

  serialize :advancement_condition, AdvancementCondition
  validates_associated :advancement_condition

  serialize :round_results, RoundResults
  validates_associated :round_results

  MAX_NUMBER = 4
  validates_numericality_of :number,
                            only_integer: true,
                            greater_than_or_equal_to: 1,
                            less_than_or_equal_to: MAX_NUMBER

  validate do
    unless event.preferred_formats.find_by_format_id(format_id)
      errors.add(:format, "'#{format_id}' is not allowed for '#{event.id}'")
    end
  end

  validate do
    if final_round? && advancement_condition
      errors.add(:advancement_condition, "cannot be set on a final round")
    end
  end

  def event
    Event.c_find(competition_event.event_id)
  end

  def final_round?
    competition_event.rounds.last == self
  end

  def self.parse_wcif_id(wcif_id)
    event_id, round_number = /^([^-]+)-r([^-]+)$/.match(wcif_id).captures
    round_number = round_number.to_i
    { event_id: event_id, round_number: round_number }
  end

  def self.wcif_id_to_name(wcif_id)
    parsed = Round.parse_wcif_id(wcif_id)
    event = Event.c_find(parsed[:event_id])
    I18n.t("round.name", event: event.name, number: parsed[:round_number])
  end

  def name
    Round.wcif_id_to_name(wcif_id)
  end

  def time_limit_to_s
    time_limit.to_s(self)
  end

  def cutoff_to_s
    cutoff ? cutoff.to_s(self) : ""
  end

  def advancement_condition_to_s
    advancement_condition ? advancement_condition.to_s(self) : ""
  end

  def self.wcif_to_round_attributes(wcif, round_number)
    {
      number: round_number,
      format_id: wcif["format"],
      time_limit: TimeLimit.load(wcif["timeLimit"]),
      cutoff: Cutoff.load(wcif["cutoff"]),
      advancement_condition: AdvancementCondition.load(wcif["advancementCondition"]),
      scramble_group_count: wcif["scrambleGroupCount"],
      round_results: RoundResults.load(wcif["roundResults"]),
    }
  end

  def wcif_id
    "#{event.id}-r#{self.number}"
  end

  def to_wcif
    {
      "id" => wcif_id,
      "format" => self.format_id,
      "timeLimit" => event.can_change_time_limit? ? time_limit&.to_wcif : nil,
      "cutoff" => cutoff&.to_wcif,
      "advancementCondition" => advancement_condition&.to_wcif,
      "scrambleGroupCount" => self.scramble_group_count,
      "roundResults" => round_results.map(&:to_wcif),
    }
  end

  def self.wcif_json_schema
    {
      "type" => "object",
      "properties" => {
        "id" => { "type" => "string" },
        "format" => { "type" => "string", "enum" => Format.pluck(:id) },
        "timeLimit" => TimeLimit.wcif_json_schema,
        "cutoff" => Cutoff.wcif_json_schema,
        "advancementCondition" => AdvancementCondition.wcif_json_schema,
        "roundResults" => { "type" => "array", "items" => { "type" => RoundResult.wcif_json_schema } },
        "groups" => { "type" => "array" }, # TODO: expand on this
        "scrambleGroupCount" => { "type" => "integer" },
      },
    }
  end
end
