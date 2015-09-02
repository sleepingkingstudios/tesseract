# spec/tesseract/unit_spec.rb

require 'tesseract/unit'

RSpec.describe Tesseract::Unit do
  shared_context 'with strict units' do
    before(:each) { instance.strict = true }
  end # shared_context

  describe '::new' do
    it { expect(described_class).to be_constructible.with(0..2).arguments }

    it { expect(described_class.new.strict?).to be false }

    describe 'with a hash of recognized units and exponents' do
      let(:units) do
        { :mass   => 1,
          :length => 2,
          :time   => -2
        } # end hash
      end # let
      let(:instance) { described_class.new(units) }

      it { expect(instance.strict?).to be false }

      it 'should set the fundamental units' do
        %i(mass length time).each do |key|
          expect(instance[key]).to be == units[key]
        end # each
      end # it

      describe 'with :strict => true' do
        let(:units) { super().merge :strict => true }

        it { expect(instance.strict?).to be true }
      end # describe
    end # describe

    describe 'with a hash of unrecognized units and exponents' do
      let(:units)    { { :kine => 2 } }
      let(:instance) { described_class.new(units) }

      it { expect(instance.strict?).to be false }

      it 'should set the fundamental units' do
        expect(instance[:kine]).to be == units[:kine]
      end # it

      describe 'with :strict => true' do
        let(:units) { super().merge :strict => true }

        it 'should raise an error' do
          expect { described_class.new units }.to raise_error ArgumentError, /is not a recognized unit/
        end # it
      end # describe
    end # describe
  end # describe

  let(:instance) { described_class.new }

  describe '#[]' do
    it { expect(instance).to respond_to(:[]).with(1).argument }

    describe 'with a nil unit' do
      it 'should raise an error' do
        expect { instance[nil] }.to raise_error ArgumentError, /is not a recognized unit/
      end # it
    end # describe

    describe 'with an object unit' do
      it 'should raise an error' do
        expect { instance[Object.new] }.to raise_error ArgumentError, /is not a recognized unit/
      end # it
    end # describe

    describe 'with an unrecognized unit string' do
      it { expect(instance['Unrecognized Unit']).to be == 0 }

      wrap_context 'with strict units' do
        it 'should raise an error' do
          expect { instance[:unrecognized_unit] }.to raise_error ArgumentError, /is not a recognized unit/
        end # it
      end # wrap_context
    end # describe

    describe 'with an unrecognized unit symbol' do
      it { expect(instance[:unrecognized_unit]).to be == 0 }

      wrap_context 'with strict units' do
        it 'should raise an error' do
          expect { instance[:unrecognized_unit] }.to raise_error ArgumentError, /is not a recognized unit/
        end # it
      end # wrap_context
    end # describe

    describe 'with a recognized unit abbreviation' do
      let(:value) { 3 }

      before(:each) { instance[:mass] = value }

      it { expect(instance['M']).to be == value }
    end # describe

    describe 'with a recognized unit string' do
      let(:value) { 3 }

      before(:each) { instance[:mass] = value }

      it { expect(instance['Mass']).to be == value }
    end # describe

    describe 'with a recognized unit symbol' do
      let(:value) { 3 }

      before(:each) { instance[:mass] = value }

      it { expect(instance[:mass]).to be == value }
    end # describe
  end # describe

  describe '#[]=' do
    it { expect(instance).to respond_to(:[]=).with(2).arguments }

    describe 'with a nil unit' do
      it 'should raise an error' do
        expect { instance[nil] = 0 }.to raise_error ArgumentError, /is not a recognized unit/
      end # it
    end # describe

    describe 'with an object unit' do
      it 'should raise an error' do
        expect { instance[Object.new] = 0 }.to raise_error ArgumentError, /is not a recognized unit/
      end # it
    end # describe

    describe 'with an unrecognized unit string' do
      wrap_context 'with strict units' do
        it 'should raise an error' do
          expect { instance['Kine'] = 0 }.to raise_error ArgumentError, /is not a recognized unit/
        end # it
      end # wrap_context

      describe 'with a nil value' do
        let(:value) { 3 }

        before(:each) { instance[:kine] = value }

        it 'should set the value to zero' do
          expect { instance['Kine'] = nil }.to change { instance[:kine] }.to 0
        end # it
      end # describe

      describe 'with a non-integer value' do
        it 'should raise an error' do
          expect { instance['Kine'] = 'not an integer' }.to raise_error ArgumentError, /must be an integer/
        end # it

        it 'should not change the value' do
          expect { begin; instance['Kine'] = 'not an integer'; rescue ArgumentError; end }.not_to change { instance[:kine] }
        end # it
      end # describe

      describe 'with an integer value' do
        let(:value) { 3 }

        it 'should change the value' do
          expect { instance['Kine'] = value }.to change { instance[:kine] }.to be == value
        end # it
      end # describe
    end # describe

    describe 'with an unrecognized unit symbol' do
      wrap_context 'with strict units' do
        it 'should raise an error' do
          expect { instance[:kine] = 0 }.to raise_error ArgumentError, /is not a recognized unit/
        end # it
      end # wrap_context

      describe 'with a nil value' do
        let(:value) { 3 }

        before(:each) { instance[:kine] = value }

        it 'should set the value to zero' do
          expect { instance[:kine] = nil }.to change { instance[:kine] }.to 0
        end # it
      end # describe

      describe 'with a non-integer value' do
        it 'should raise an error' do
          expect { instance[:kine] = 'not an integer' }.to raise_error ArgumentError, /must be an integer/
        end # it

        it 'should not change the value' do
          expect { begin; instance[:kine] = 'not an integer'; rescue ArgumentError; end }.not_to change { instance[:kine] }
        end # it
      end # describe

      describe 'with an integer value' do
        let(:value) { 3 }

        it 'should change the value' do
          expect { instance[:kine] = value }.to change { instance[:kine] }.to be == value
        end # it
      end # describe
    end # describe

    describe 'with a recognized unit abbreviation' do
      describe 'with a nil value' do
        let(:value) { 3 }

        before(:each) { instance[:temperature] = value }

        it 'should set the value to zero' do
          expect { instance['Θ'] = nil }.to change { instance[:temperature] }.to 0
        end # it
      end # describe

      describe 'with a non-integer value' do
        it 'should raise an error' do
          expect { instance['Θ'] = 'not an integer' }.to raise_error ArgumentError, /must be an integer/
        end # it

        it 'should not change the value' do
          expect { begin; instance['Θ'] = 'not an integer'; rescue ArgumentError; end }.not_to change { instance[:temperature] }
        end # it
      end # describe

      describe 'with an integer value' do
        let(:value) { 3 }

        it 'should change the value' do
          expect { instance['Θ'] = value }.to change { instance[:temperature] }.to be == value
        end # it
      end # describe
    end # describe

    describe 'with a recognized unit string' do
      describe 'with a nil value' do
        let(:value) { 3 }

        before(:each) { instance[:electric_charge] = value }

        it 'should set the value to zero' do
          expect { instance['Electric Charge'] = nil }.to change { instance[:electric_charge] }.to 0
        end # it
      end # describe

      describe 'with a non-integer value' do
        it 'should raise an error' do
          expect { instance['Electric Charge'] = 'not an integer' }.to raise_error ArgumentError, /must be an integer/
        end # it

        it 'should not change the value' do
          expect { begin; instance['Electric Charge'] = 'not an integer'; rescue ArgumentError; end }.not_to change { instance[:electric_charge] }
        end # it
      end # describe

      describe 'with an integer value' do
        let(:value) { 3 }

        it 'should change the value' do
          expect { instance['Electric Charge'] = value }.to change { instance[:electric_charge] }.to be == value
        end # it
      end # describe
    end # describe

    describe 'with a recognized unit symbol' do
      describe 'with a nil value' do
        let(:value) { 3 }

        before(:each) { instance[:mass] = value }

        it 'should set the value to zero' do
          expect { instance[:mass] = nil }.to change { instance[:mass] }.to 0
        end # it
      end # describe

      describe 'with a non-integer value' do
        it 'should raise an error' do
          expect { instance[:mass] = 'not an integer' }.to raise_error ArgumentError, /must be an integer/
        end # it

        it 'should not change the value' do
          expect { begin; instance[:mass] = 'not an integer'; rescue ArgumentError; end }.not_to change { instance[:mass] }
        end # it
      end # describe

      describe 'with an integer value' do
        let(:value) { 3 }

        it 'should change the value' do
          expect { instance[:mass] = value }.to change { instance[:mass] }.to be == value
        end # it
      end # describe
    end # describe
  end # describe

  include_examples 'should have property', :strict, false

  describe '#inspect' do
    it { expect(instance).to respond_to(:inspect).with(0).arguments }

    context 'with a fundamental unit with zero exponent' do
      before(:each) { instance[:mass] = 0 }

      it { expect(instance.inspect).to be == '' }
    end # context

    context 'with a fundamental unit with unit exponent' do
      before(:each) { instance[:mass] = 1 }

      it { expect(instance.inspect).to be == 'mass' }
    end # context

    context 'with a fundamental unit with positive exponent' do
      before(:each) { instance[:mass] = 3 }

      it { expect(instance.inspect).to be == 'mass^3' }
    end # context

    context 'with a fundamental unit with negative exponent' do
      before(:each) { instance[:mass] = -3 }

      it { expect(instance.inspect).to be == 'mass^-3' }
    end # context

    context 'with a mixed group of units' do
      before(:each) do
        instance[:mass]        = 1
        instance[:length]      = 2
        instance[:time]        = -2
        instance[:temperature] = 0
      end # before each

      it { expect(instance.inspect).to be == 'mass length^2 / time^2' }
    end # context
  end # describe

  describe '#strict?' do
    it { expect(instance).to respond_to(:strict?).with(0).arguments }

    it { expect(instance.strict?).to be false }

    wrap_context 'with strict units' do
      it { expect(instance.strict?).to be true }
    end # wrap_context
  end # describe

  describe '#to_s' do
    it { expect(instance).to respond_to(:to_s).with(0).arguments }

    context 'with a fundamental unit with zero exponent' do
      before(:each) { instance[:mass] = 0 }

      it { expect(instance.to_s).to be == '' }
    end # context

    context 'with a fundamental unit with unit exponent' do
      before(:each) { instance[:mass] = 1 }

      it { expect(instance.to_s).to be == 'M' }
    end # context

    context 'with a fundamental unit with positive exponent' do
      before(:each) { instance[:mass] = 3 }

      it { expect(instance.to_s).to be == 'M3' }
    end # context

    context 'with a fundamental unit with negative exponent' do
      before(:each) { instance[:mass] = -3 }

      it { expect(instance.to_s).to be == 'M-3' }
    end # context

    context 'with a mixed group of units' do
      before(:each) do
        instance[:mass]        = 1
        instance[:length]      = 2
        instance[:time]        = -2
        instance[:temperature] = 0
      end # before each

      it { expect(instance.to_s).to be == 'ML2T-2' }
    end # context
  end # describe

  ### Comparisons ###

  describe '#==' do
    it { expect(instance).to respond_to(:==).with(1).argument }

    pending
  end # describe

  ### Operations ###
end # describe
