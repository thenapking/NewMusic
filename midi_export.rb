require_relative 'package'
require 'midilib/sequence'
require 'midilib/consts'
include MIDI

FLATS=  %w(C Db D Eb E F Gb G Ab A Bb B)
SHARPS= %w(C C# D D# E F F# G G# A A# B)
ROMAN=  %w(I bII II bIII III IV #IV V bVI VI bVII VII)
INTERVALS = %w(R b9 9 b3 3 11 #11 5 #5 6 b7 7)
NUMBER_OF_NOTES = 12
ROOT_NOTE = 64
BPM = 130
NUMBER_OF_TRACKS = 3
REPETITIONS = NUMBER_OF_TRACKS * 8



pentatonics = SequenceFinder.new(intervals: [1,2,3,4,5], d: 5, n: 12)
rhythms = SequenceFinder.new(intervals: [1,2,3,4,5,6,7,8], d: 5, n: 16)
pulse_rhythms = [[4,4,4,4],[2,2,2,2,2,2,2,2]]
pulse_rhythm = IntervalSequence.new(intervals: pulse_rhythms.first, max: 16)

a = rhythms.sequences.first
b = pentatonics.sequences.first

default_note_length = 'sixteenth'
pulse = Cell.new( rhythmic_sequence: pulse_rhythm,
                  melodic_sequence: IntervalSequence.new(values: [a.values.first], max: 12), 
                  name: 'pulse')
clave = Cell.new(rhythmic_sequence: a, melodic_sequence: b, name: "Bossa 2")


cells = [clave, clave.rotate(2), clave.transpose(7).rotate(1)]


transformations = [[:identity],[:transpose, 2],[:rotate, 3]]

cells.each do |cell|
  seq = Sequence.new()
  seq.note_to_delta(default_note_length)
  track = Track.new(seq)
  seq.tracks << track
  track.events << Tempo.new(Tempo.bpm_to_mpq(BPM))
  track.events << MetaEvent.new(META_SEQ_NAME, cell.name)

  track.name = cell.name
  track.instrument = GM_PATCH_NAMES[0]

  
  transformed_cells = transformations.collect { |t| cell.send(*t) }.compact

  transformed_cells.each do |c|
    shellings = (0..c.last_onset).collect { |m|  c.dup.shell(*(0..(m-1)).map { |j| j }) }

    shellings.each do |d|
      REPETITIONS.times do 
        (0..d.last_onset).each do |i|
          track.events << NoteOn.new(0,  ROOT_NOTE + d.melodic_sequence[i], 127, 0)
          track.events << NoteOff.new(0, ROOT_NOTE + d.melodic_sequence[i], 127, d.rhythmic_intervals[i] * cell.rhythmic_base)
        end
      end
    end
  end
  File.open("./output/#{cell.name}.mid", 'wb') { |file| seq.write(file) }
end

