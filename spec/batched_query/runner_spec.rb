require 'spec_helper'

describe BatchedQuery::Runner do
  describe ".each_set" do
    let(:query) do
      double("User", pluck: [1,2], where: [1, 2])
    end

    before do
      BatchedQuery::Runner.limit = 1
    end

    it "calls the block twice" do
      expect { |b| BatchedQuery::Runner.each_set(query, &b) }.to yield_control.exactly(2).times
    end

    it "splits the query into two parts" do
      BatchedQuery::Runner.each_set(query) do |current_number|
        #do nothing
      end

      expect(query).to have_received(:where).with(:id => [1])
      expect(query).to have_received(:where).with(:id => [2])
    end

    it "calls block with each query subset" do
      total = []
      BatchedQuery::Runner.each_set(query) do |current_subset|
        total = total + current_subset
      end

      expect(total).to eq([1, 2, 1, 2])
    end
  end

  describe ".each_result" do
    let(:query) do
      double("User", pluck: [1,2], where: [1, 2])
    end

    before do
      BatchedQuery::Runner.limit = 2
    end

    it "calls the block twice" do
      expect { |b| BatchedQuery::Runner.each_result(query, &b) }.to yield_control.exactly(2).times
    end

    it "calls block with each query result" do
      total = 0
      BatchedQuery::Runner.each_result(query) do |current_result|
        total = total + current_result
      end

      expect(total).to eq(3)
    end
  end
end
