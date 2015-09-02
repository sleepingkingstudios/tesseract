# lib/tesseract/unit.rb

module Tesseract
  class Unit
    FUNDAMENTAL_UNITS = {
      :length          => 'L',
      :mass            => 'M',
      :time            => 'T',
      :temperature     => 'Θ',
      :electric_charge => 'Q'
    } # end hash
    FUNDAMENTAL_UNIT_ABBREVIATIONS = FUNDAMENTAL_UNITS.each.with_object({}) do |(name, abbr), hsh|
      hsh[abbr] = name
    end # each

    attr_accessor :strict

    def initialize units_or_opts = {}, opts = nil
      @fundamental_units = Hash.new(0)

      opts ||= units_or_opts
      self.strict = opts.delete(:strict) || false

      units_or_opts.each do |key, value|
        self[key] = value
      end # each
    end # constructor

    def [] key
      @fundamental_units[normalize_key! key]
    end # method []

    def []= key, value
      value = 0 if value.nil?

      raise ArgumentError.new 'value must be an integer' unless value.is_a?(Integer)

      @fundamental_units[normalize_key! key] = value
    end # method []=

    def inspect
      str = ''

      positive = @fundamental_units.select { |_, value| value > 0 }
      negative = @fundamental_units.select { |_, value| value < 0 }

      positive.each.with_index do |(key, value), index|
        str << ' ' if index > 0

        str << key.to_s

        str << '^' << value.to_s if value != 1
      end # each

      str << ' / ' if !positive.empty? && !negative.empty?

      negative.each.with_index do |(key, value), index|
        str << ' ' if index > 0

        str << key.to_s

        str << '^' << (positive.empty? ? value : -value).to_s if value != 1
      end # each

      str.strip
    end # method inspect

    def strict?
      !!strict
    end # method strict

    def to_s
      str = ''

      @fundamental_units.each do |key, value|
        next if value == 0

        str << FUNDAMENTAL_UNITS[key] || key.to_s

        str << value.to_s if value != 1
      end # each

      str
    end # method to_s

    private

    def normalize_key! key
      normalized = case key
      when String
        FUNDAMENTAL_UNIT_ABBREVIATIONS[key] || key.sub(/[\s-]+/, '_').downcase.intern
      when Symbol
        key
      else
        raise ArgumentError.new "#{key.inspect} is not a recognized unit"
      end # case

      raise ArgumentError.new "#{key.inspect} is not a recognized unit" if strict? && !FUNDAMENTAL_UNITS.key?(normalized)

      normalized
    end # method normalize_key
  end # class
end # module
