# frozen_string_literal: true

class ComputeLinkings < SingletonApplicationJob
  queue_as :default

  def perform
    last_computation = Timestamp.find_or_create_by(name: 'linkings_computation')
    if last_computation.not_after?(3.days.ago)
      Relations.compute_linkings
      last_computation.touch :date
    end
  end
end
