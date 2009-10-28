require 'verstehen'
require 'test/unit'

class TestVerstehen < Test::Unit::TestCase
  def test_simple
    assert_equal(
      [0, 1, 2, 3, 4], 
      list { x }.for(:x).in{ 0..4 }.comprehend) 
  end

  def test_simple_expression
    assert_equal(
      [0, 5, 10, 15, 20], 
      list { x * 5 }.for(:x).in{ 0..4 }.comprehend) 
  end

  def test_simple_condition
    assert_equal(
      [0, 64, 128, 192, 256], 
      list { x * 16 }.for(:x).in{ 0..16 }.if{ x % 4 == 0 }.comprehend)
  end

  def test_string
    word = "spam"
    assert_equal(
      [["", "spam"], ["s", "pam"], ["sp", "am"], ["spa", "m"], ["spam", ""]], 
      list { [word[0, i], word[i, word.length]] }.for(:i).in{ 0..word.length }.comprehend)
  end

  def test_2d_range
    assert_equal(
      [1, 2, 2, 4], 
      list { x * y }.for(:x).in{ 0...3 }.for(:y).in{ 0...3 }.if{ x > 0 and y > 0 }.comprehend)
  end

  def test_3d_range
   assert_equal(
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 2, 4, 0, 0, 0, 0, 2, 4, 0, 4, 8], 
    list { x * y * z }.for(:x).in{ 0...3 }.for(:y).in{ 0...3 }.for(:z).in{0...3}.comprehend)
  end

  def test_reference_outer
    assert_equal(
    [:a, :b, :c, :d, :e, :f, :g, :h, :i],
    list { l2 }.for(:l1).in{ [[:a, :b, :c], [:d, :e, :f], [:g, :h, :i]] }.for(:l2).in{ l1 }.comprehend)
  end
end
