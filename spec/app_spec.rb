require_relative 'spec_helper'

RSpec.describe App do
  let(:output_temp_file) { Tempfile.new('csv') }

  after { output_temp_file.unlink }

  subject { described_class.new(output_temp_file.path).call }

  describe '#call' do
    context 'when there are no interruptions', :vcr do
      it 'writes all customers to the file' do
        subject
        csv = CSV.open(output_temp_file.path, headers: true).read
        expect(csv.count).to eq(644)
      end
    end

    context 'when the program is relaunched after interruption', :vcr do
      let(:partially_filled_csv) { File.open('spec/fixtures/customers_interrupted.csv') }
      let(:amount_of_customers_during_interruption) { 3 }
      let(:amount_of_customers_in_total) { 644 }

      before do
        File.open(output_temp_file, 'w') { |file| file.puts partially_filled_csv.read }
      end

      it 'appends more customers to the file' do
        expect { subject }.to change \
          { CSV.open(output_temp_file.path, headers: true).read.count }.
          from(amount_of_customers_during_interruption).
          to(amount_of_customers_in_total)
      end
    end
  end
end
