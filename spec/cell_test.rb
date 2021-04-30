require 'minitest/autorun'
require_relative '../package'

class CellTest < Minitest::Test

  def setup
    @m = IntervalSequence.new(intervals: [2,2,2,3,3], max: 12, name: 'Minor Pentatonic')
    @r = IntervalSequence.new(intervals: [3,3,3,3,4], max: 16, name: 'Bossa Nova')
    @cell = Cell.new(rhythmic_sequence: @r, melodic_sequence: @m, name: "#{@m.name} #{@r.name}")

    # m = [0, 2, 4, 7, 10]
    # r = [0, 3, 6, 9, 13]
  end

  def teardown
    @m = nil
    @r = nil
    @cell = nil
  end

  def test_transposition
    #Act
    transpose_up = @cell.transpose(1)
    transpose_down = @cell.transpose(-1)
    #Assert
    assert(transpose_up.melodic_sequence == [1, 3, 5, 8, 11])
    assert(transpose_down.melodic_sequence == [-1, 1, 3, 6, 9])
  end

  def test_rotation
    #Act
    rotate_forwards  = @cell.rotate(1)
    rotate_backwards = @cell.rotate(2).rotate(-1)
    #Assert
    assert(rotate_forwards.rhythmic_sequence  == [1, 4, 7, 10, 14])
    assert(rotate_backwards.rhythmic_sequence == [1, 4, 7, 10, 14] )
  end

  def test_shelling
    # Note that to shell the items you create the lists below

    # Arrange
    m = 3

    #Act
    shell_from_left =   @cell.dup.shell(*(0..(m-1)).map { |i| i })
    shell_from_right =  @cell.dup.shell(*(0..(m-1)).map { |i| @cell.last_onset - i } )
    shell_from_middle = @cell.dup.shell(*(1..m).map { |i| @cell.middle_onset + (i/2) * (-1) ** i })

    #Assert
    assert(shell_from_left.rhythmic_sequence   == [9, 13])
    assert(shell_from_left.melodic_sequence    == [7, 10])
    assert(shell_from_right.rhythmic_sequence  == [0, 3] )
    assert(shell_from_right.melodic_sequence   == [0, 2] )
    assert(shell_from_middle.melodic_sequence  == [0, 10])
    assert(shell_from_middle.rhythmic_sequence == [0, 13])
  end

  def test_combination
    #Act
    rotate_transpose_up = @cell.rotate(1).transpose(1)
    #Assert
    assert(rotate_transpose_up.melodic_sequence    == [1, 3, 5, 8, 11] ) 
    assert(rotate_transpose_up.rhythmic_sequence   == [1, 4, 7, 10, 14]) 
  end
end