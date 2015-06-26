describe BatchedQuery, ".run" do

  class User < ActiveRecord::Base
  end

  context "when there are many records" do
    let(:query) { User.order("id ASC") }

    before do
      stub_const("BatchedQuery::LIMIT_PER_QUERY", 1)
      create_list(:client, 2)
      allow(query).to receive(:where).and_call_original
    end

    it "calls the block twice" do
      expect { |b| BatchedQuery.run(query, &b) }.to yield_control.exactly(2).times
    end

    it "splits the query into two parts" do
      BatchedQuery.run(query) do |client|
        #do nothing
      end

      expect(query).to have_received(:where).with(:id => [User.first.id])
      expect(query).to have_received(:where).with(:id => [User.last.id])
    end
  end

  context "when there are only a few records" do
    let(:query) { User.order("id ASC") }

    before do
      stub_const("BatchedQuery::LIMIT_PER_QUERY", 3)
      create_list(:client, 2)
      allow(query).to receive(:where).and_call_original
    end

    it "calls the block twice" do
      expect { |b| BatchedQuery.run(query, &b) }.to yield_control.exactly(2).times
    end

    it "doesn't split the query into parts" do
      BatchedQuery.run(query) do |client|
        #do nothing
      end

      expect(query).to have_received(:where).with(:id => [User.first.id, User.last.id])
    end
  end
end
