require 'set'

class SequenceFinder
  # Generates scales and euclidean rhythms

  attr_accessor :n, :d, :intervals, :ordered
  
  def initialize(args = {})
    # n is the interval sum
    # d is the number of divisions
    # intervals is the list of valid intervals, usually it is best that i < n/2 for all i in intervals
    @n = args[:n]
    @d = args[:d]
    @intervals = args[:intervals]
    @ordered = args[:ordered] || true
  end

  def combinations
    x = @intervals.repeated_combination(d).uniq.select { |c| c.sum == n }
    ordered ? x.collect { |w| w.permutation(d).uniq } : x
  end
  
  def sequences
    # This finds an interval sequence
    if @ordered
      combinations.collect {|s| s.collect {|t| IntervalSequence.new(intervals: t, max: n)}.flatten}.flatten.sort_by { |s| s.evenness } 
    else
      combinations.collect {|t| IntervalSequence.new(intervals: t, max: n)}.sort_by { |s| s.evenness }
    end
  end
end