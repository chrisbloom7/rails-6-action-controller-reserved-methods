ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"
require 'minitest/reporters'
require 'csv'

class ReservedMethodReporter < Minitest::Reporters::BaseReporter
  REPORTS_DIR = "test/reports"
  REPORT_PREFIX = "ReservedMethodsTest"

  def initialize(options = {})
    super

    @reports_path = File.absolute_path(REPORTS_DIR)

    puts "Emptying #{@reports_path}"
    FileUtils.mkdir_p(@reports_path)
    File.delete(*Dir.glob("#{@reports_path}/#{REPORT_PREFIX}-*.csv"))
  end

  def report
    super

    timestamp = Time.now.strftime('%Y%m%d%H%M%S%L')
    filename = File.join(@reports_path, "#{REPORT_PREFIX}-#{timestamp}.csv")
    puts "Writing CSV report to #{filename}"
    CSV.open(filename, "w") do |csv|
      tests.reject(&:passed?).map do |test|
        e = test.failure
        call_type = if test.name =~ /indirectly/
          "called indirectly"
        else
          "called directly"
        end

        csv << [
          test.error? ? "Error" : "Failure",
          test.name.split("`").second,
          call_type,
          e.message.split("\n").first,
        ]
      end
    end
  end
end

Minitest::Reporters.use! ReservedMethodReporter.new

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
