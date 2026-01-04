# frozen_string_literal: true

class TestComponent < Draco::Component
  attribute :test, default: 1
end

class TestComponent2 < Draco::Component
  attribute :test, default: 2
end

class TestEntity < Draco::Entity
  component TestComponent, test: 3
  component :test_component2, test: 4
  component :alternate_name, class_name: "TestComponent", test: 5
  component Tag(:test_tag)
end

RSpec.describe Draco::Entity do
  describe ".initialize" do
    let(:entity) { Draco::Entity.new }

    it "has an id" do
      expect(entity.id).to be
    end

    it "has a list of components" do
      expect(entity.components).to be_empty
    end
  end

  describe "#serialize" do
    let(:entity) { TestEntity.new }
    subject { entity.serialize }

    it "serializes the id" do
      expect(subject[:id]).to eq(entity.id)
    end

    it "serialize the class" do
      expect(subject[:class]).to eq("TestEntity")
    end

    it "serializes the components" do
      expect(subject[:test_component]).to be
    end
  end

  describe "#inspect" do
    subject { TestEntity.new.inspect }

    it { is_expected.to be }
  end

  describe "#to_s" do
    subject { TestEntity.new.to_s }

    it { is_expected.to be }
  end

  describe "#<component_name>" do
    context "for 'component TestComponent'" do
      subject { TestEntity.new.test_component }

      it { is_expected.to be }
      it { expect(subject.test).to be(3) }
    end
    context "for 'component :test_component2'" do
      subject { TestEntity.new.test_component2 }

      it { is_expected.to be }
      it { expect(subject.test).to be(4) }
    end
    context "for 'component :alternate_name, class_name: 'TestComponent'" do
      subject { TestEntity.new.alternate_name }

      it { is_expected.to be }
      it { expect(subject.test).to be(5) }
    end
  end

  describe "#<component_name> for Tag component" do
    subject { TestEntity.new.test_tag }

    it { is_expected.to be }
  end

  describe "#method_missing" do
    subject { TestEntity.new }

    it "raises a NoMethodError error with no matching component" do
      expect { subject.no_component }.to raise_error(NoMethodError)
    end
  end

  describe "entity's components not shared" do
    subject { TestEntity.new }
    let(:sibling) { TestEntity.new }

    it {
      expect do
        subject.test_component2.test = 7
      end.to_not(change { sibling.test_component2.test })
    }
  end
end
