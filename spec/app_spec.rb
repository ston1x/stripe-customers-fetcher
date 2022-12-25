require_relative 'spec_helper'

# TODO: Pass the Tempfile
subject { described_class.new.call }

RSpec.describe App do
  describe '#call' do
    context 'when no interruptions happen' do
    end

    context 'when the program is relaunched after interruption' do
    end

    context 'when a RateLimitError happens' do
    end
  end
end
