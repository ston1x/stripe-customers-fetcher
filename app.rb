require 'dotenv/load'
require 'pry'
require 'csv'
require 'stripe'

class App
  Stripe.log_level = Stripe::LEVEL_INFO
  Stripe.api_key   = ENV.fetch('STRIPE_API_KEY')

  DEFAULT_OUTPUT_FILE_NAME = 'customers.csv'.freeze
  PAGE_LIMIT               = 50

  def initialize(output_file_name = DEFAULT_OUTPUT_FILE_NAME)
    @output_file_name = output_file_name
  end

  def call
    prepare_csv

    loop do
      customers = fetch_customers

      break if customers.empty?

      append_to_csv(customers)
    rescue Stripe::RateLimitError
      sleep 10
      retry
    end
  end

  private

  def prepare_csv
    return if File.exist?(@output_file_name)

    CSV.open('customers.csv', 'w') do |csv|
      csv << %w[ID Name Email]
    end
  end

  def fetch_customers
    Stripe::Customer.list(
      {
        limit: PAGE_LIMIT,
        starting_after: last_id_from_csv_or_nil
      }
    )
  end

  def append_to_csv(customers)
    CSV.open(@output_file_name, 'a') do |csv|
      customers.each do |customer|
        csv << [customer.id, customer.name, customer.email]
      end
    end
  end

  def last_id_from_csv_or_nil
    csv = CSV.read(@output_file_name, headers: true)
    (csv[csv.count - 1] || {}).fetch('ID', nil)
  end
end
