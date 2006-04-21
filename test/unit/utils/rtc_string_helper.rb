require File.dirname(__FILE__) + "/../../test_helper"


class StringHelperTest < Test::Unit::TestCase
  include Ferret::Utils

  def test_string_difference()
    assert_equal(3, StringHelper.string_difference("David", "Dave"))
    assert_equal(0, StringHelper.string_difference("David", "Erik"))
    assert_equal(4, StringHelper.string_difference("book", "bookworm"))
  end

  def test_string_reader
    sr = StringHelper::StringReader.new("TestString")
    assert_equal("T", sr.read(1))
    assert_equal("es", sr.read(2))
    assert_equal("tStr", sr.read(4))
    assert_equal("ing", sr.read(100))
    assert_nil(sr.read(100))
  end
end