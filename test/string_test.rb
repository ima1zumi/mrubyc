# coding: utf-8

class StringTest < MrubycTestCase

  description "String.new with arg"
  def string_new_with_arg
    str = String.new("a string instance")
    assert_equal "a string instance", str
    utf8_str = String.new("あいう")
    assert_equal "あいう", utf8_str
  end

  description "String.new without arg"
  def string_new_without_arg
    str = String.new
    assert_equal "", str
  end

  description "==, !="
  def op_eq_case
    assert_equal true, "abc" == "abc"
    assert_equal false, "abc" == "ABC"
    assert_equal false, "abc" == "abcd"
    assert_equal false, "abc" != "abc"
    assert_equal true, "abc" != "ABC"
    assert_equal true, "あいう" == "あいう"
    assert_equal true, "𩸽" == "𩸽" # outer BMP
    assert_equal false, "A" == "À"
    assert_equal false, "あいう" == "あいうえ"
    assert_equal false, "あいう" != "あいう"
    assert_equal true, "ace" != "àçè"
  end

  description "self * times -> String"
  def mul_case
    s1 = "ABCDEFG"
    s2 = "0123456789"
    s3 = "あいう"
    assert_equal "ABCDEFGABCDEFG", s1 * 2
    assert_equal "abcabc", "abc" * 2
    assert_equal "01234567890123456789", s2 * 2
    assert_equal "あいうあいう", s3 * 2
  end

  description "self + other -> String"
  def add_case
    s1 = "ABCDEFG"
    s2 = "0123456789"
    s3 = "あいう"
    assert_equal "ABCDEFG0123456789", s1 + s2
    assert_equal "ABCDEFG123", s1 + "123"
    assert_equal "abc0123456789", "abc" + s2
    assert_equal "abc123", "abc" + "123"
    assert_equal "あいう0123456789ABCDEFG", s3 + s2 + s1
    assert_equal "ABCDEFGあいう0123456789", s1 + s3 + s2
    assert_equal "ABCDEFG0123456789あいう", s1 + s2 + s3
    assert_equal "ABCDEFGあい", s1 + "あい"
    assert_equal "あい0123456789", "あい" + s2
    assert_equal "あい𩸽", "あい" + "𩸽"
  end

  description "self << other -> self"
  def addi_case
    s1 = "ABCDEFG"
    s2 = "0123456789"
    s3 = "あいう"
    s1 << s2
    assert_equal "ABCDEFG0123456789", s1
    s1 << "abc"
    assert_equal "ABCDEFG0123456789abc", s1
    assert_equal "abcdef", "abc" << "def"
    s1 << 65
    assert_equal "ABCDEFG0123456789abcA", s1
    s1 << s3
    assert_equal "ABCDEFG0123456789abcAあいう", s1
    assert_equal "あいう𩸽", "あいう" << "𩸽"
    # s1 << 227
    # FIXME
    # assert_equal "ABCDEFG0123456789abcAあいうã", s1
    # s1 << 129
    # FIXME
    # assert_equal "ABCDEFG0123456789abcAあいうã\u0081", s1
    # s1 << 130
    # assert_equal "ABCDEFG0123456789abcAあいうあ", s1
  end

  description "self <=> other -> (minus) | 0 | (plus)"
  def compare_case
    assert ("aaa" <=> "xxx") < 0
    assert ("aaa" <=> "aaa") == 0
    assert ("xxx" <=> "aaa") > 0
    assert ("string" <=> "stringAA") < 0
    assert ("string" <=> "string") == 0
    assert ("stringAA" <=> "string") > 0
    assert ("あ" <=> "い") < 0
    assert ("い" <=> "い") == 0
    assert ("い" <=> "あ") > 0
    assert ("あ" <=> "ああ") < 0
    assert ("ああ" <=> "あ") > 0
  end

  description "self == other -> bool"
  def op_eq_2_case
    s1 = "ABCDEFG"
    s2 = "あいう"
    assert_equal "ABCDEFG", s1
    assert_equal "あいう", s2
  end

  description "self[nth] -> String | nil"
  def nth_case
    assert_equal "r", 'bar'[2]
    assert_equal true, 'bar'[2] == ?r
    assert_equal "r", 'bar'[-1]
    assert_equal nil, 'bar'[3]
    assert_equal nil, 'bar'[-4]
    assert_equal "い", 'あいう'.utf8_slice(1)
  end

  description "self[nth, len] -> String | nil"
  def nth_len_case
    str0 = "bar"
    assert_equal "r", str0[2, 1]
    assert_equal "",  str0[2, 0]
    assert_equal "r", str0[2, 100]  # (右側を超えても平気
    assert_equal "r", str0[-1, 1]
    assert_equal "r", str0[-1, 2]   # (あくまでも「右に向かって len 文字」

    assert_equal "", str0[3, 1]
    assert_equal nil, str0[4, 1]
    assert_equal nil, str0[-4, 1]
    str1 = str0[0, 2]               # (str0 の「一部」を str1 とする
    assert_equal "ba", str1
    str1[0] = "XYZ"
    assert_equal "XYZa", str1     #(str1 の内容が破壊的に変更された
    assert_equal "bar", str0      #(str0 は無傷、 str1 は str0 と内容を共有していない
  end

  description "境界値チェックを詳細にかけておく"
  def boundary_value_case
    s1 = "0123456"

    assert_equal "012", s1[0,3]
    assert_equal "123", s1[1,3]
    assert_equal "", s1[1,0]
    assert_equal "123456", s1[1,30]

    assert_equal nil, s1[3,-1]
    assert_equal nil, s1[3,-3]
    assert_equal nil, s1[3,-4]
    assert_equal nil, s1[3,-5]

    assert_equal "6", s1[6,1]
    assert_equal "", s1[6,0]
    assert_equal "", s1[7,1]     # ??
    assert_equal "", s1[7,0]     # ??
    assert_equal nil, s1[7,-1]
    assert_equal nil, s1[7,-2]
    assert_equal nil, s1[8,1]
    assert_equal nil, s1[8,0]
    assert_equal nil, s1[8,-1]
    assert_equal nil, s1[8,-2]


    assert_equal "", s1[-3,0]
    assert_equal "45", s1[-3,2]
    assert_equal "456", s1[-3,3]
    assert_equal "456", s1[-3,4]

    assert_equal "", s1[-1,0]
    assert_equal "6", s1[-1,1]
    assert_equal "6", s1[-1,2]
    assert_equal "12", s1[-6,2]
    assert_equal "01", s1[-7,2]
    assert_equal nil, s1[-8,0]
    assert_equal nil, s1[-8,1]

    assert_equal nil, s1[-3,-1]
  end

  description "self[nth] = val"
  def nth_replace_case
    s1 = "0123456789"
    s1[0] = "ab"
    assert_equal "ab123456789", s1

    s1 = "0123456789"
    s1[1] = "ab"
    assert_equal "0ab23456789", s1

    s1 = "0123456789"
    s1[9] = "ab"
    assert_equal "012345678ab", s1

    s1 = "0123456789"
    s1[10] = "ab"
    assert_equal "0123456789ab", s1

    s1 = "0123456789"
    s1[-1] = "ab"
    assert_equal "012345678ab", s1

    s1 = "0123456789"
    s1[-2] = "ab"
    assert_equal "01234567ab9", s1

    s1 = "0123456789"
    s1[-10] = "ab"
    assert_equal "ab123456789", s1

    s1 = "0123456789"
    s1[0] = ""
    assert_equal "123456789", s1

    s1 = "0123456789"
    s1[1] = ""
    assert_equal "023456789", s1

    s1 = "0123456789"
    s1[9] = ""
    assert_equal "012345678", s1

    s1 = "0123456789"
    s1[10] = ""
    assert_equal "0123456789", s1

    s1 = "0123456789"
    s1[-1] = ""
    assert_equal "012345678", s1

    s1 = "0123456789"
    s1[-2] = ""
    assert_equal "012345679", s1

    s1 = "0123456789"
    s1[-10] = ""
    assert_equal "123456789", s1
  end

  description "self[nth, len] = val"
  def nth_len_replace_case
    s1 = "0123456789"
    s1[2,5] = "ab"
    assert_equal "01ab789", s1

    s1 = "0123456789"
    s1[2,8] = "ab"
    assert_equal "01ab", s1

    s1 = "0123456789"
    s1[2,9] = "ab"
    assert_equal "01ab", s1

    s1 = "0123456789"
    s1[2,1] = "ab"
    assert_equal "01ab3456789", s1

    s1 = "0123456789"
    s1[2,0] = "ab"
    assert_equal "01ab23456789", s1


    s1 = "0123456789"
    s1[0,5] = "ab"
    assert_equal "ab56789", s1

    s1 = "0123456789"
    s1[0,10] = "ab"
    assert_equal "ab", s1

    s1 = "0123456789"
    s1[0,99] = "ab"
    assert_equal "ab", s1


    s1 = "0123456789"
    s1[9,1] = "ab"
    assert_equal "012345678ab", s1

    s1 = "0123456789"
    s1[10,1] = "ab"
    assert_equal "0123456789ab", s1

    s1 = "0123456789"
    s1[10,0] = "ab"
    assert_equal "0123456789ab", s1


    s1 = "0123456789"
    s1[2,5] = ""
    assert_equal "01789", s1

    s1 = "0123456789"
    s1[2,8] = ""
    assert_equal "01", s1

    s1 = "0123456789"
    s1[2,9] = ""
    assert_equal "01", s1

    s1 = "0123456789"
    s1[2,1] = ""
    assert_equal "013456789", s1

    s1 = "0123456789"
    s1[2,0] = ""
    assert_equal "0123456789", s1


    s1 = "0123456789"
    s1[0,5] = ""
    assert_equal "56789", s1

    s1 = "0123456789"
    s1[0,10] = ""
    assert_equal "", s1

    s1 = "0123456789"
    s1[0,99] = ""
    assert_equal "", s1


    s1 = "0123456789"
    s1[9,1] = ""
    assert_equal "012345678", s1

    s1 = "0123456789"
    s1[10,1] = ""
    assert_equal "0123456789", s1

    s1 = "0123456789"
    s1[10,0] = ""
    assert_equal "0123456789", s1
  end

  description "minus"
  def minus_case
    s1 = "0123456789"
    s1[-8,5] = "ab"
    assert_equal "01ab789", s1

    s1 = "0123456789"
    s1[-8,8] = "ab"
    assert_equal "01ab", s1

    s1 = "0123456789"
    s1[-8,9] = "ab"
    assert_equal "01ab", s1

    s1 = "0123456789"
    s1[-8,1] = "ab"
    assert_equal "01ab3456789", s1

    s1 = "0123456789"
    s1[-8,0] = "ab"
    assert_equal "01ab23456789", s1


    s1 = "0123456789"
    s1[-1,1] = "ab"
    assert_equal "012345678ab", s1

    s1 = "0123456789"
    s1[-1,0] = "ab"
    assert_equal "012345678ab9", s1
  end

  description "String#slice!"
  def slice_self_case
    s = "bar"
    assert_equal "r", s.slice!(2)
    assert_equal "ba", s

    s = "bar"
    assert_equal "r", s.slice!(-1)
    assert_equal "ba", s

    s = "bar"
    assert_equal nil, s.slice!(3)
    assert_equal "bar", s

    s = "bar"
    assert_equal nil, s.slice!(-4)
    assert_equal "bar", s

    s = "bar"
    assert_equal "r", s.slice!(2, 1)
    assert_equal "ba", s

    s = "bar"
    assert_equal "",  s.slice!(2, 0)
    assert_equal "bar", s

    s = "bar"
    assert_equal "r", s.slice!(2, 100)
    assert_equal "ba", s

    s = "bar"
    assert_equal "r", s.slice!(-1, 1)
    assert_equal "ba", s

    s = "bar"
    assert_equal "r", s.slice!(-1, 2)
    assert_equal "ba", s

    s = "bar"
    assert_equal "", s.slice!(3, 1)
    assert_equal "bar", s

    s = "bar"
    assert_equal nil, s.slice!(4, 1)
    assert_equal "bar", s

    s = "bar"
    assert_equal nil, s.slice!(-4, 1)
    assert_equal "bar", s
  end

  description "ord"
  def ord_case
    assert_equal 97, "a".ord
    assert_equal 97, "abcde".ord

    assert_raise(ArgumentError.new("empty string")) do
      "".ord
    end
  end

  description "binary string"
  def binary_case
    s1 = "ABC\x00\x0d\x0e\x0f"
    assert_equal 7, s1.size

    i = 0
    while i < 3
      s1[i] = i.chr
      i += 1
    end
    assert_equal "\x00\x01\x02\x00\x0d\x0e\x0f", s1
    while i < 10
      s1[i] = i.chr
      i += 1
    end
    assert_equal 10, s1.size
    assert_equal "\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09", s1
  end

  description "String#size"
  def string_size_case
    s = "abc"
    assert_equal 3, s.size
    assert_equal 3, s.length

    s = ""
    assert_equal 0, s.size
    assert_equal 0, s.length

    s = "\0"
    assert_equal 1, s.size
    assert_equal 1, s.length

  description "utf-8 size"
  def utf8_size
    s1 = "a"
    s2 = "aà"
    s3 = "aàあ"
    s4 = "aàあ𩸽"
    assert_equal 1, s1.utf8_size
    assert_equal 2, s2.utf8_size
    assert_equal 3, s3.utf8_size
    assert_equal 4, s4.utf8_size
  end

  description "index"
  def index_case
    assert_equal 0, "abcde".index("")
    assert_equal 0, "abcde".index("a")
    assert_equal 0, "abcde".index("abc")
    assert_equal 1, "abcde".index("bcd")
    assert_equal 3, "abcde".index("de")
    assert_equal nil, "abcde".index("def")

    assert_equal 2, "abcde".index("c",1)
    assert_equal 2, "abcde".index("c",2)
    assert_equal nil, "abcde".index("c",3)
  end

  description "tr"
  def tr_case
    assert_equal "123defg", "abcdefg".tr("abc", "123")
    assert_equal "123d456", "abcdefg".tr("abcefg", "123456")
    assert_equal "123333g", "abcdefg".tr("abcdef", "123")

    assert_equal "123defg", "abcdefg".tr("a-c", "123")
    assert_equal "123d456", "abcdefg".tr("a-ce-g", "123456")
    assert_equal "123d456", "abcdefg".tr("a-cefg", "123456")

    assert_equal "143defg", "abcdefg".tr("a-cb", "123456")
    assert_equal "143de56", "abcdefg".tr("a-cbfg", "123456")
    assert_equal "14567fg", "abcdefg".tr("a-cb-e", "123456789")

    assert_equal "a999999", "abcdefg".tr("^a", "123456789")
    assert_equal "abc9999", "abcdefg".tr("^abc", "123456789")
    assert_equal "abc9999", "abcdefg".tr("^a-c", "123456789")
    assert_equal "^23defg", "abcdefg".tr("abc", "^23456789")

    # Illegal Cases
    assert_equal "abcdefg",  "abcdefg".tr("", "123456789")
    assert_equal "abc1defg", "abc^defg".tr("^", "123456789")
    assert_equal "abc1defg", "abc-defg".tr("-", "123456789")
    assert_equal "1bc2defg", "abc-defg".tr("a-", "123456789")
    assert_equal "123-defg", "abc-defg".tr("a-c", "123456789")
    assert_equal "ab21defg", "abc-defg".tr("-c", "123456789")

    # delete
    assert_equal "defg", "abcdefg".tr("abc", "")
    assert_equal "abc", "abcdefg".tr("^abc", "")

    # range replace
    assert_equal "FOO", "foo".tr('a-z', 'A-Z')
    assert_equal "foo", "FOO".tr('A-Z', 'a-z')
    assert_equal "12cABC", "abcdef".tr("abd-f", "12A-C")
  end

  description "start_with?"
  def start_with_case
    assert_true  "abc".start_with?("")
    assert_true  "abc".start_with?("a")
    assert_true  "abc".start_with?("ab")
    assert_true  "abc".start_with?("abc")
    assert_true  "あいう".start_with?("")
    assert_true  "あいう".start_with?("あ")
    assert_true  "あいう".start_with?("あい")
    assert_true  "あいう".start_with?("あいう")
    assert_false "abc".start_with?("abcd")
    assert_false "abc".start_with?("A")
    assert_false "abc".start_with?("aA")
    assert_false "abc".start_with?("b")
    assert_false "あいう".start_with?("あいうえ")
    assert_false "あいう".start_with?("い")
    assert_false "あいう".start_with?("いう")
    assert_false "あいう".start_with?("え")
  end

  description "end_with?"
  def end_with_case
    assert_true  "abc".end_with?("")
    assert_true  "abc".end_with?("c")
    assert_true  "abc".end_with?("bc")
    assert_true  "abc".end_with?("abc")
    assert_true  "あいう".end_with?("")
    assert_true  "あいう".end_with?("う")
    assert_true  "あいう".end_with?("いう")
    assert_true  "あいう".end_with?("あいう")
    assert_false "abc".end_with?(" abc")
    assert_false "abc".end_with?("C")
    assert_false "abc".end_with?("Bc")
    assert_false "abc".end_with?("b")
    assert_false "あいう".end_with?(" あいう")
    assert_false "あいう".end_with?("え")
    assert_false "あいう".end_with?("い")
    assert_false "あいう".end_with?("あい")
  end

  description "include?"
  def include_case
    assert_true  "abc".include?("")
    assert_true  "abc".include?("a")
    assert_true  "abc".include?("b")
    assert_true  "abc".include?("c")
    assert_true  "abc".include?("ab")
    assert_true  "abc".include?("bc")
    assert_true  "abc".include?("abc")
    assert_false "abc".include?("abcd")
    assert_false "abc".include?(" abc")
    assert_false "abc".include?("A")
    assert_false "abc".include?("aB")
    assert_false "abc".include?("abC")
    assert_true  "あいう".include?("")
    assert_true  "あいう".include?("あ")
    assert_true  "あいう".include?("い")
    assert_true  "あいう".include?("う")
    assert_true  "あいう".include?("あい")
    assert_true  "あいう".include?("いう")
    assert_true  "あいう".include?("あいう")
    assert_false "あいう".include?("あいうえ")
    assert_false "あいう".include?(" あいう")
  end

  description "to_f, to_i, to_s"
  def to_something_case
    assert_equal 10.0, "10".to_f
    assert_equal 1000.0, "10e2".to_f
    assert_equal 0.25, "25e-2".to_f
    assert_equal 0.25, ".25".to_f

    # not support this case.
    #assert_equal 0.0, "nan".to_f
    #assert_equal 0.0, "INF".to_f
    #assert_equal( -0.0, "-Inf".to_f )

    assert_equal 0.0, "".to_f
    #assert_equal 100.0, "1_0_0".to_f
    assert_equal 10.0, " \n10".to_f
    #assert_equal 0.0, "0xa.a".to_f

    assert_equal 10, " 10".to_i
    assert_equal 10, "+10".to_i
    assert_equal( -10, "-10".to_i )

    assert_equal 10, "010".to_i
    assert_equal( -10, "-010".to_i )

    assert_equal 0, "0x11".to_i
    assert_equal 0, "".to_i

    assert_equal 1, "01".to_i(2)
    #assert_equal 1, "0b1".to_i(2)

    assert_equal 7, "07".to_i(8)
    #assert_equal 7, "0o7".to_i(8)

    assert_equal 31, "1f".to_i(16)
    #assert_equal 31, "0x1f".to_i(16)

    # not support this case.
    #assert_equal 2, "0b10".to_i(0)
    #assert_equal 8, "0o10".to_i(0)
    #assert_equal 8, "010".to_i(0)
    #assert_equal 10, "0d10".to_i(0)
    #assert_equal 16, "0x10".to_i(0)

    assert_equal "str", "str".to_s
    assert_equal "あいう", "あいう".to_s
  end

  description "String#bytes chars"
  def string_bytes_chars
    assert_equal [97, 98, 99], "abc".bytes
    assert_equal [227, 129, 130, 227, 129, 132, 227, 129, 134], "あいう".bytes
  end

  description "String#bytes empty"
  def string_bytes_empty
    assert_equal [], "".bytes
  end

  description "String#bytes null char"
  def string_bytes_null_char
    assert_equal [97, 0, 98], "a\000b".bytes
    assert_equal [227, 129, 130, 0, 227, 129, 132], "あ\000い".bytes
  end

  description "String#dup"
  def string_dup_case
    assert_equal "a", "a".dup
    assert_equal "abc", "abc".dup
    assert_equal "", "".dup
  end

  description "String#empty?"
  def string_empty_question_case
    assert_true  "".empty?
    assert_false "a".empty?
    assert_false "abc".empty?
    assert_false " ".empty?
    assert_false "\0".empty?
  end

  description "String#clear"
  def string_clear_case
    s = "abc"
    assert_equal "", s.clear
    assert_equal "", s
  end

  description "String#getbyte"
  def string_getbyte_case
    s = "abc"
    assert_equal 97, s.getbyte(0)
    assert_equal 98, s.getbyte(1)
    assert_equal 99, s.getbyte(2)
    assert_equal nil, s.getbyte(3)
    assert_equal 99, s.getbyte(-1)
  end

  description "String#inspect"
  def string_inspect_case
    assert_equal "\"\\x00\"", "\0".inspect
    assert_equal "\"foo\"", "foo".inspect
  end

  description "String#upcase"
  def string_upcase
    assert_equal "ABC", "abc".upcase
    assert_equal "ABC", "ABC".upcase
    assert_equal "ABC", "aBc".upcase
    assert_equal "ABC", "AbC".upcase
    assert_equal "ABC", "aBC".upcase
    assert_equal "ABC", "Abc".upcase
    assert_equal "ABC", "abc".upcase
    assert_equal "A\0BC", "a\0bc".upcase
  end

  description "String#upcase!"
  def string_upcase_bang
    str = "\0abc"
    ret = str.upcase!
    assert_equal "\0ABC", ret
    assert_equal "\0ABC", str
    assert_equal str, ret
    assert_nil "ABC".upcase!
  end

  description "String#downcase"
  def string_downcase
    assert_equal "abc", "abc".downcase
    assert_equal "a\0bc", "A\0BC".downcase
    assert_equal "abc", "aBc".downcase
    assert_equal "abc", "AbC".downcase
    assert_equal "abc", "aBC".downcase
    assert_equal "abc", "Abc".downcase
    assert_equal "abc", "abc".downcase
  end

  description "String#downcase!"
  def string_downcase_bang
    str = "A\0BC"
    ret = str.downcase!
    assert_equal "a\0bc", ret
    assert_equal "a\0bc", str
    assert_equal str, ret
    assert_nil "abc".downcase!
  end

end
