class IntervalSequence
  # An interval sequence
  include Enumerable
  attr_accessor :intervals, :values, :name, :max

  def initialize(args = {})
    @name = args[:name]
    @max = args[:max] || 12
    if !args[:intervals].nil?
      @intervals = args[:intervals]
      @values =  [] 

      (0..(@intervals.length-1)).each do |c| 
        if c == 0 
          @values << 0 
        else
          @values << (@intervals[c] + @values.last) % @max
        end
      end
    else
      @values = args[:values].uniq
      @values =    (0..(@values.length-1)).map { |i| (@values[i] - @values[0]) % @max  }
      @intervals = (0..(@values.length-1)).map { |c| (@values[(c + 1) % @values.length] - @values[c]) % @max}
    end
    return false if !args[:values].is_a? Array
  end

  def each(&block)
    intervals.each(&block)
  end

  def evenness
    self.collect { |i| i*i }.reduce(:+)
  end

  def delete_intervals(*args)
    new_values = values.dup
    args.each { |i| new_values[i] = nil  }
    IntervalSequence.new(values: new_values.compact, max: max) 
  end

  alias_method :length, :count
  alias_method :delete_interval, :delete_intervals
end