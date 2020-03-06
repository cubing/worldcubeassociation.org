# frozen_string_literal: true

module ResultsValidators
  class PersonsValidator < GenericValidator
    PERSON_WITHOUT_RESULTS_ERROR = "Person with id %{person_id} (%{person_name}) has no result"
    RESULTS_WITHOUT_PERSON_ERROR = "Results for unknown person with id %{person_id}"
    WHITESPACE_IN_NAME_ERROR = "Person '%{name}' has leading/trailing whitespaces or double whitespaces."
    WRONG_WCA_ID_ERROR = "Person %{name} has a WCA ID which does not exist: %{wca_id}."
    WRONG_PARENTHESIS_FORMAT_ERROR = "Opening parenthesis in '%{name}' must be preceeded by a space."
    DOB_0101_WARNING = "The date of birth of %{name} is on January 1st, please make sure it's correct."
    VERY_YOUNG_PERSON_WARNING = "%{name} seems to be less than 3 years old, please make sure it's correct."
    NOT_SO_YOUNG_PERSON_WARNING = "%{name} seems to be around 100 years old, please make sure it's correct."
    SAME_PERSON_NAME_WARNING = "Person '%{name}' exists with one or multiple WCA IDs (%{wca_ids}) in the WCA database."\
      " A person in the uploaded results has the same name but has no WCA ID: please make sure they are different (and add a message about this to the WRT), or fix the results JSON."
    NON_MATCHING_DOB_WARNING = "Wrong birthdate for %{name} (%{wca_id}), expected '%{expected_dob}' got '%{dob}'."
    NON_MATCHING_GENDER_WARNING = "Wrong gender for %{name} (%{wca_id}), expected '%{expected_gender}' got '%{gender}'."
    EMPTY_GENDER_WARNING = "Gender for newcomer %{name} is empty, please leave a comment to the WRT about this."
    NON_MATCHING_NAME_WARNING = "Wrong name for %{wca_id}, expected '%{expected_name}' got '%{name}'. If the competitor did not change their name then fix the name to the expected name."
    NON_MATCHING_COUNTRY_WARNING = "Wrong country for %{name} (%{wca_id}), expected '%{expected_country}' got '%{country}'. If this is an error, fix it. Otherwise, do leave a comment to the WRT about it."

    @@desc = "This validator checks that Persons data make sense with regard to the competition results and the WCA database."

    def self.has_automated_fix?
      false
    end

    def validate(competition_ids: [], model: Result, results: nil)
      reset_state
      # Get all results if not provided
      results ||= model.sorted_for_competitions(competition_ids)
      results_by_competition_id = results.group_by(&:competitionId)

      competitions = Hash[
        Competition.where(id: results_by_competition_id.keys).map do |c|
          [c.id, c]
        end
      ]
      results_by_competition_id.each do |competition_id, results_for_comp|
        persons_by_id = Hash[
          if model == Result
            competitions[competition_id].competitors.map { |p| [p.wca_id, p] }
          else
            InboxPerson.where(competitionId: competition_id).map { |p| [p.id, p] }
          end
        ]
        detected_person_ids = persons_by_id.keys
        persons_with_results = results_for_comp.map(&:personId)
        (detected_person_ids - persons_with_results).each do |person_id|
          @errors << ValidationError.new(:persons, competition_id,
                                         PERSON_WITHOUT_RESULTS_ERROR,
                                         person_id: person_id,
                                         person_name: persons_by_id[person_id].name)
        end
        (persons_with_results - detected_person_ids).each do |person_id|
          @errors << ValidationError.new(:persons, competition_id,
                                         RESULTS_WITHOUT_PERSON_ERROR,
                                         person_id: person_id)
        end

        without_wca_id, with_wca_id = persons_by_id.values.partition { |p| p.wca_id.empty? }
        if without_wca_id.any?
          existing_person_in_db_by_name = Person.where(name: without_wca_id.map(&:name)).group_by(&:name)
          existing_person_in_db_by_name.each do |name, persons|
            @warnings << ValidationWarning.new(:persons, competition_id,
                                               SAME_PERSON_NAME_WARNING,
                                               name: name,
                                               wca_ids: persons.map(&:wca_id).join(", "))
          end
        end
        without_wca_id.each do |p|
          if p.dob.month == 1 && p.dob.day == 1
            @warnings << ValidationWarning.new(:persons, competition_id,
                                               DOB_0101_WARNING,
                                               name: p.name)
          end
          if p.gender.blank?
            @warnings << ValidationWarning.new(:persons, competition_id,
                                               EMPTY_GENDER_WARNING,
                                               name: p.name)
          end
          # Competitor less than 3 years old are extremely rare, so we'd better check these birthdate are correct.
          if p.dob.year >= Time.now.year - 3
            @warnings << ValidationWarning.new(:persons, competition_id,
                                               VERY_YOUNG_PERSON_WARNING,
                                               name: p.name)
          end
          if p.dob.year <= Time.now.year - 100
            @warnings << ValidationWarning.new(:persons, competition_id,
                                               NOT_SO_YOUNG_PERSON_WARNING,
                                               name: p.name)
          end
          # Look for double whitespaces or leading/trailing whitespaces.
          unless p.name.squeeze(" ").strip == p.name
            @errors << ValidationError.new(:persons, competition_id,
                                           WHITESPACE_IN_NAME_ERROR,
                                           name: p.name)
          end
          if /[[:alnum:]]\(/ =~ p.name
            @errors << ValidationError.new(:persons, competition_id,
                                           WRONG_PARENTHESIS_FORMAT_ERROR,
                                           name: p.name)
          end
        end
        existing_person_by_wca_id = Hash[Person.current.where(wca_id: with_wca_id.map(&:wca_id)).map { |p| [p.wca_id, p] }]
        with_wca_id.each do |p|
          existing_person = existing_person_by_wca_id[p.wca_id]
          if existing_person
            # WRT wants to show warnings for wrong person information.
            # (If I get this right, we do not actually update existing persons from InboxPerson)
            unless p.dob == existing_person.dob
              @warnings << ValidationWarning.new(:persons, competition_id,
                                                 NON_MATCHING_DOB_WARNING,
                                                 name: p.name, wca_id: p.wca_id,
                                                 expected_dob: existing_person.dob,
                                                 dob: p.dob)
            end
            unless p.gender == existing_person.gender
              @warnings << ValidationWarning.new(:persons, competition_id,
                                                 NON_MATCHING_GENDER_WARNING,
                                                 name: p.name, wca_id: p.wca_id,
                                                 expected_gender: existing_person.gender,
                                                 gender: p.gender)
            end
            unless p.name == existing_person.name
              @warnings << ValidationWarning.new(:persons, competition_id,
                                                 NON_MATCHING_NAME_WARNING,
                                                 name: p.name, wca_id: p.wca_id,
                                                 expected_name: existing_person.name)
            end
            unless p.country.id == existing_person.country.id
              @warnings << ValidationWarning.new(:persons, competition_id,
                                                 NON_MATCHING_COUNTRY_WARNING,
                                                 name: p.name, wca_id: p.wca_id,
                                                 expected_country: existing_person.country_iso2,
                                                 country: p.countryId)
            end
          else
            @errors << ValidationError.new(:persons, competition_id,
                                           WRONG_WCA_ID_ERROR,
                                           name: p.name, wca_id: p.wca_id)
          end
        end
      end
      self
    end
  end
end
