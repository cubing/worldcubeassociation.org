# frozen_string_literal: true
class TestDbManager
  CONSTANT_TABLES = %w(Countries Continents Events Rounds Formats committees).freeze

  def self.fill_tables
    Dir["db/seeds/*.seeds.rb"].each { |file| load file }
  end
end

describe TestDbManager do
  it "CONSTANT_TABLES includes all tables filled in the files inside /db/seeds/ directory" do
    expected_files = TestDbManager::CONSTANT_TABLES.map do |table_name|
      "db/seeds/#{table_name.underscore}.seeds.rb"
    end
    expect(Dir["db/seeds/*.seeds.rb"]).to match_array expected_files
  end
end
