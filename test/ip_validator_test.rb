require 'test_helper'

class IpValidatorTest < Minitest::Test

  def test_validates_ip4_addresses
    assert IpValidator.new('0.0.0.0').valid_ip4?
    assert IpValidator.new('1.12.123.123').valid_ip4?
    assert IpValidator.new('126.218.035.038').valid_ip4?
  end

  def test_max_3_digit_groups_in_ip4_addresses
    refute IpValidator.new('1234.123.123.123').valid_ip4?
    refute IpValidator.new('12.1234.12.12').valid_ip4?
    refute IpValidator.new('1.1.1.1234').valid_ip4?
    refute IpValidator.new('1234.1234.1234.1234').valid_ip4?
  end

  def test_no_non_digits_in_ip4_address
    refute IpValidator.new('1a.123.123.123').valid_ip4?
    refute IpValidator.new('123.123.123.12R').valid_ip4?
    refute IpValidator.new('123.1%3.123.123').valid_ip4?
    refute IpValidator.new('123.123.12_.123').valid_ip4?
  end

  def test_correct_number_format_in_ip4_address
    refute IpValidator.new('123.123.123').valid_ip4?
    refute IpValidator.new('123..123.123').valid_ip4?
    refute IpValidator.new('123.123.123.123.123').valid_ip4?
    refute IpValidator.new('1.1.1.1.1').valid_ip4?
    refute IpValidator.new('123.123.123.').valid_ip4?
    refute IpValidator.new('123.123.123.123.').valid_ip4?
  end

  def test_correct_number_range_in_ip4_address
    assert IpValidator.new('1.2.3.4').valid_ip4?
    assert IpValidator.new('11.22.33.44').valid_ip4?
    assert IpValidator.new('111.222.233.244').valid_ip4?
    refute IpValidator.new('1111.2222.3333.4444').valid_ip4?
    assert IpValidator.new('0.0.0.0').valid_ip4?
    assert IpValidator.new('00.00.00.00').valid_ip4?
    assert IpValidator.new('000.000.000.000').valid_ip4?
    refute IpValidator.new('0000.0000.0000.0000').valid_ip4?
    assert IpValidator.new('156.156.156.156').valid_ip4?
    assert IpValidator.new('255.255.255.255').valid_ip4?
    refute IpValidator.new('256.256.256.256').valid_ip4?
    refute IpValidator.new('311.311.311.311').valid_ip4?
    assert IpValidator.new('01.02.03.04').valid_ip4?
    assert IpValidator.new('001.002.003.004').valid_ip4?
    assert IpValidator.new('012.012.012.012').valid_ip4?
    refute IpValidator.new('0123.0123.0123.0123').valid_ip4?
    refute IpValidator.new('-4.123.123.123').valid_ip4?
    refute IpValidator.new('123.280.123.123').valid_ip4?
  end

  def test_validates_ip6_addresses
    assert IpValidator.new('0:0:0:0:0:0:0:0').valid_ip6?
    assert IpValidator.new('1:12:123:1234:a:ab:abc:abcd').valid_ip6?
    assert IpValidator.new('A123:0DEF:a123:0def:A123:0DEF:a123:0def').valid_ip6?
  end

  def test_validates_ip6_addresses_with_compression
    assert IpValidator.new('12af::12af:12af:12af:12af:12af:12af').valid_ip6?
    assert IpValidator.new('12af::12af:12af:12af:12af:12af').valid_ip6?
    assert IpValidator.new('::12af:12af:12af:12af:12af').valid_ip6?
    assert IpValidator.new('12af:12af:12af:12af::').valid_ip6?
    assert IpValidator.new('12af::12af:12af:12af:12af').valid_ip6?
    assert IpValidator.new('12af::12af:12af:12af').valid_ip6?
    assert IpValidator.new('12af::12af:12af').valid_ip6?
    assert IpValidator.new('12af::12af').valid_ip6?
    assert IpValidator.new('::12af').valid_ip6?
    assert IpValidator.new('::').valid_ip6?
  end

  def test_ip6_addresses_with_incorrect_compression
    refute IpValidator.new('12af:::12af:12af:12af:12af').valid_ip6?
    refute IpValidator.new('12af::12af:12af::12af').valid_ip6?
  end

  def test_max_4_digit_groups_in_ip6_addresses
    refute IpValidator.new('12345::1234').valid_ip6?
    refute IpValidator.new('1234:1234:12345:1234:1234:1234:1234:1234').valid_ip6?
    refute IpValidator.new('1234:1234:12345::1234:1234:1234:1234').valid_ip6?
  end

  def test_no_non_allowed_characters_in_ip6_address
    refute IpValidator.new('123G:1234:1234:1234:1234:1234:1234:1234').valid_ip6?
    refute IpValidator.new('123&:1234:1234:1234:1234:1234:1234:1234').valid_ip6?
    refute IpValidator.new('12_4:1234:1234:1234:1234:1234:1234:1234').valid_ip6?
  end

  def test_correct_number_format_in_ip6_address
    refute IpValidator.new('1234:1234:1234:1234:1234:1234:1234').valid_ip6?
    refute IpValidator.new('1234:1234:1234:1234:1234:1234:1234:1234:1234').valid_ip6?
    refute IpValidator.new('1:1:1:1:1:1:1:1:1').valid_ip6?
    refute IpValidator.new('1234:1234:1234:1234:1234:1234:1234:1234:').valid_ip6?
    refute IpValidator.new('1234:1234:1234:1234:1234:1234:1234:1234:1234:').valid_ip6?
  end

  def test_correct_number_range_in_ip6_address
    refute IpValidator.new('00000:00000:00000:00000:00000:00000:00000:00000').valid_ip6?
    assert IpValidator.new('0000:0000:0000:0000:0000:0000:0000:0000').valid_ip6?
    assert IpValidator.new('000:000:000:000:000:000:000:000').valid_ip6?
    assert IpValidator.new('00:00:00:00:00:00:00:00').valid_ip6?
    assert IpValidator.new('0:0:0:0:0:0:0:0').valid_ip6?
    assert IpValidator.new('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff').valid_ip6?
    assert IpValidator.new('f:f:f:f:f:f:f:f').valid_ip6?
    refute IpValidator.new('g:g:g:g:g:g:g:g').valid_ip6?
    refute IpValidator.new('01234:0:0:0:0:0:0:0').valid_ip6?
    assert IpValidator.new('0123:0123:0123:0123:0123:0123:0123:0123').valid_ip6?
    assert IpValidator.new('0012:0012:0012:0012:0012:0012:0012:0012').valid_ip6?
    assert IpValidator.new('0001:0001:0001:0001:0001:0001:0001:0001').valid_ip6?
    refute IpValidator.new('00001:00001:00001:00001:00001:00001:00001:00001').valid_ip6?
    refute IpValidator.new('-123:0123:0123:0123:0123:0123:0123:0123').valid_ip6?
  end
end
