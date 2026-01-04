# frozen_string_literal: true

class TestComponent < Draco::Component
  attribute :test, default: 1
end

class TestComponent2 < Draco::Component
  attribute :test, default: 2
end

class TestEntity < Draco::Entity
  component TestComponent, test: 3
  component :alternate_name, class_name: "TestComponent", test: 5
  component Tag(:test_tag)
end
RSpec.describe Draco::Entity::ComponentStore do
  let(:entity) { TestEntity.new }
  let(:new_component) { TestComponent2.new(name: "alternative_name") }
  subject { described_class.new(entity) }

  describe "#add" do
    it "adds TestComponent2" do
      subject.add(new_component)
      expect(subject[:alternative_name].test).to be(2)
    end
  end

  describe "#delete" do
    context "when component is given" do
      it "removes TestComponent2" do
        subject.add(new_component)
        expect do
          subject.delete(new_component)
        end.to change { subject[:alternative_name] }.to be_nil
      end
    end
    context "when alternative name is given" do
      it "removes TestComponent2" do
        subject.add(new_component)
        expect do
          subject.delete(:alternative_name)
        end.to change { subject[:alternative_name] }.to be_nil
      end
    end
  end
end
