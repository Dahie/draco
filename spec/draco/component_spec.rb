# frozen_string_literal: true

class SampleComponent < Draco::Component
  attr_reader :test

  attribute :name
  attribute :velocity, default: 0

  def initialize(values = {})
    super
    @test = true
  end
end

class SampleSharedComponent < Draco::Component
  shared_attribute :velocity, default: 0
  shared_attribute :list, default: []
end

class ListComponent < Draco::Component
  attribute :list, default: []
  delegate(:each, :count, :<<, to: :list)
end

RSpec.describe Draco::Component do
  describe "attribute" do
    subject { SampleComponent.new }

    it "defaults to nil" do
      expect(subject.name).to be(:sample_component)
    end

    it "defaults to the given default value" do
      expect(subject.velocity).to eq(0)
    end

    it "runs the overridden initializer" do
      expect(subject.test).to be true
    end

    context "with ListComponent" do
      subject { ListComponent.new }
      let(:sibling) { ListComponent.new }

      it "it changes on instance" do
        expect do
          subject.list << "Example"
        end.to_not(change { sibling.list.count })
      end
    end
    context "with SampleComponent" do
      subject { SampleComponent.new }
      let(:sibling) { SampleComponent.new }

      it "it changes on instance" do
        expect do
          subject.velocity = 10
        end.to_not(change { sibling.velocity })
      end
    end
  end

  xdescribe ".shared_attribute" do
    subject { SampleSharedComponent.new }
    let(:sibling) { SampleSharedComponent.new }
    it "it changes velocity in both instances" do
      expect do
        subject.velocity = 10
      end.to(change { sibling.velocity }).from(0).to(10)
    end
    it "it changes list in both instances" do
      expect do
        subject.list << "example"
      end.to change { sibling.list.count }.from(0).to(1)
    end
  end

  describe "#serialize" do
    subject { SampleComponent.new.serialize }

    it "serializes the class" do
      expect(subject[:class]).to eq("SampleComponent")
    end

    it "serializes the attributes" do
      expect(subject[:name]).to be(:sample_component)
      expect(subject[:velocity]).to eq(0)
    end
  end

  describe "#inspect" do
    subject { SampleComponent.new.inspect }

    it { is_expected.to be }
  end

  describe "#to_s" do
    subject { SampleComponent.new.to_s }

    it { is_expected.to include("object_id") }
    it { is_expected.to include("id") }
    it { is_expected.to include("class") }
    it { is_expected.to include("name") }
  end

  describe "delegate" do
    context "with ListComponent" do
      subject { ListComponent.new }

      context "when calling count" do
        it "it returns 1" do
          subject.list << "Example"
          expect(subject.count).to be(1)
        end

        it "responds_to :count" do
          expect(subject.respond_to?(:count)).to be(true)
        end
      end
      context "when calling <<" do
        it "it returns 2" do
          expect do
            subject.list << "Example"
            subject << "Example"
          end.to change { subject.count }.by(2)
        end
        it "responds_to :<<" do
          expect(subject.respond_to?(:<<)).to be(true)
        end
      end
      context "when calling :each" do
        it "it calls " do
          subject.list << "Example1"
          subject.each do |e|
            expect(e).to eq("Example1")
          end
        end
        it "responds_to :<<" do
          expect(subject.respond_to?(:<<)).to be(true)
        end
      end
    end
  end
end
