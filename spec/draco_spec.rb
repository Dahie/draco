# frozen_string_literal: true

RSpec.describe Draco do
  describe ".underscore" do
    {
      Draco => "draco",
      Draco::Entity => "draco/entity",
      "Draco" => "draco",
      "Draco::Entity" => "draco/entity"
    }.each do |example, expectation|
      context "with example #{example}" do
        subject { Draco.underscore(example) }

        let(:example) { example }
        let(:expectation) { expectation }

        specify { is_expected.to eql(expectation) }
      end
    end
  end

  describe ".camelize" do
    {
      "draco" => "Draco",
      "draco/entity" => "Draco::Entity"
    }.each do |example, expectation|
      context "with example #{example}" do
        subject { Draco.camelize(example) }

        let(:example) { example }
        let(:expectation) { expectation }

        specify { is_expected.to eql(expectation) }
      end
    end
  end

  describe ".constantize" do
    {
      "Draco" => Draco,
      "Draco::Entity" => Draco::Entity
    }.each do |example, expectation|
      context "with example #{example}" do
        subject { Draco.constantize(example) }

        let(:example) { example }
        let(:expectation) { expectation }

        specify { is_expected.to eql(expectation) }
      end
    end
  end

  describe "VERSION" do
    it "has a version number" do
      expect(Draco::VERSION).not_to be nil
    end
  end
end
