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

seq = Sequence.new()

pentatonics = SequenceFinder.new(intervals: [1,2,3,4,5], d: 5, n: 12)
rhythms = SequenceFinder.new(intervals: [1,2,3,4,5,6,7,8], d: 5, n: 16)
pulse_rhythms = [[4,4,4,4],[2,2,2,2,2,2,2,2]]
pulse_rhythm = IntervalSequence.new(intervals: pulse_rhythms.first, max: 16)

a = rhythms.sequences.first
b = pentatonics.sequences.first

note_length = seq.note_to_delta('sixteenth')
clave = Cell.new(rhythmic_sequence: a, melodic_sequence: b, name: "Bossa")


cells = [clave, clave.rotate(2), clave.transpose(7).rotate(1)]
transformations = [[:identity],[:transpose, 2],[:rotate, 3]]

cell = cells[1]
transformed_cells = transformations.collect { |t| cell.send(*t) }.compact

c = transformed_cells.first
shellings = (0..c.last_onset).collect { |m|  c.dup.shell(*(0..(m-1)).map { |j| j }) }


