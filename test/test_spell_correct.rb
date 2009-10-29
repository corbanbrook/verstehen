# The following test is a ruby port of Peter Norvig's Spelling Corrector http://norvig.com/spell-correct.html
# His examples of python list comprehension gave me the idea to write a list comprehension library in ruby.

require 'helper'

def words(text); text.downcase.scan /[a-z]+/; end

def train(words) 
  model = Hash.new(0)
  words.each { |w| model[w] += 1 }
  model
end

NWORDS = train(words("the quick brown fox jumps over the lazy dog"))
ALPHABET = 'a'..'z' 

def edits1(word)
  # Peter Norvig's examples of Python list comprehension, much cleaner then the ruby syntax..

  # s = [(word[:i], word[i:]) for i in range(len(word) + 1)]
  # deletes    = [a + b[1:] for a, b in s if b]
  # transposes = [a + b[1] + b[0] + b[2:] for a, b in s if len(b)>1]
  # replaces   = [a + c + b[1:] for a, b in s for c in alphabet if b]
  # inserts    = [a + c + b     for a, b in s for c in alphabet]

  s =           list { [word[0, i], word[i, word.length]]    }.for(:i).in { 0..word.length }.comprehend
  deletes =     list { a + b[1, b.length]                    }.for(:a, :b).in { s }.if { b.any? }.comprehend
  transposes =  list { a + b[1,1] + b[0,1] + b[2, b.length]  }.for(:a, :b).in { s }.if { b.length > 1 }.comprehend
  replaces =    list { a + c + b[1, b.length]                }.for(:a, :b).in { s }.for(:c).in { ALPHABET }.if { b.any? }.comprehend
  inserts =     list { a + c + b                             }.for(:a, :b).in { s }.for(:c).in { ALPHABET }.comprehend
  deletes + transposes + replaces + inserts
end

def known_edits2(word)
  result = list { e2 }.for(:e1).in { edits1(word) }.for(:e2).in { edits1(e1) }.if { NWORDS.has_key? e2 }.comprehend
  result.empty? ? nil : result
end

def known(words)
  result = words.select { |w| NWORDS.has_key? w }
  result.empty? ? nil : result
end

def correct(word)
  (known([word]) or known(edits1(word)) or known_edits2(word) or [word]).max { |a, b| NWORDS[a] <=> NWORDS[b] }
end

class TestSpellCorrect < Test::Unit::TestCase
  def test_spell_correct
    assert_equal('jumps', correct('jugs'))
  end
end
