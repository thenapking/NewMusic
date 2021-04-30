require_relative 'interval_sequence'

class Cell

  attr_accessor :rhythmic_sequence, :melodic_sequence, 
  :rhythmic_intervals, :melodic_intervals, :rhythmic_base, :melodic_base, :name


  def initialize(args)
    self.name = args[:name] || 'default'
    self.melodic_base = args[:melodic_base] || 12
    
    if args[:rhythmic_sequence].is_a?(IntervalSequence)
      self.rhythmic_base = args[:rhythmic_sequence].max
      self.rhythmic_intervals = args[:rhythmic_sequence].intervals
      self.rhythmic_sequence =  args[:rhythmic_sequence].values
    elsif  args[:rhythmic_sequence].is_a?(Array)
      self.rhythmic_base = args[:rhythmic_base] || 16
      self.rhythmic_intervals = IntervalSequence.new(values:args[:rhythmic_sequence], max: rhythmic_base).intervals
      self.rhythmic_sequence =  args[:rhythmic_sequence]
    else
      false
    end

    if args[:melodic_sequence].is_a?(IntervalSequence)
      self.melodic_base = args[:melodic_sequence].max
      self.melodic_intervals = args[:melodic_sequence].intervals
      self.melodic_sequence =  args[:melodic_sequence].values
    elsif  args[:melodic_sequence].is_a?(Array)
      self.melodic_base = args[:melodic_base] || 16
      self.melodic_intervals = IntervalSequence.new(values:args[:melodic_sequence], max: melodic_base).intervals
      self.melodic_sequence =  args[:melodic_sequence]
    else
      false
    end

  end

  def last_onset
    length - 1
  end

  def middle_onset
    (length / 2)
  end

  def length
    rhythmic_sequence.count
  end

  def identity
    self
  end

  def transpose(i)
    Cell.new(melodic_sequence: melodic_sequence.collect {|n| n+i },
    rhythmic_sequence: rhythmic_sequence,
    rhythmic_base: rhythmic_base,
    melodic_base: melodic_base,
    name: "#{name} transposed #{i}" )
  end

  def rotate(i)
    Cell.new(melodic_sequence: melodic_sequence,
    rhythmic_sequence: rhythmic_sequence.collect {|n| (n+i) % rhythmic_base },
    rhythmic_base: rhythmic_base,
    melodic_base: melodic_base,
    name: "#{name} rotated #{i}" )
  end

  def shell(*args)
    new_rhythm = rhythmic_sequence.dup
    new_melody = melodic_sequence.dup

    args.each { |i| new_rhythm[i] = nil  }
    args.each { |i| new_melody[i] = nil  } 

    Cell.new(melodic_sequence: new_melody.compact,
    rhythmic_sequence: new_rhythm.compact,
    rhythmic_base: rhythmic_base,
    melodic_base: melodic_base,
    name: "#{name} shelled of #{args.join('-')}" )

  end

end
