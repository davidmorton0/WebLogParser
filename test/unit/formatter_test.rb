# frozen_string_literal: true

require 'test_helper'

# Tests for Formatter class
class FormatterTest < Minitest::Test
  include TestData
  include ColorText
  include Constants

  def test_adds_title
    formatter = Formatter.new
    assert_equal [], formatter.output
    formatter.add_title(title: 'Info Title')
    assert_equal 'Info Title', formatter.output[1]
  end

  def test_adds_line_breaks_around_title
    formatter = Formatter.new
    formatter.add_title(title: 'Info Title')
    assert_equal '----------', formatter.output[0]
    assert_equal '----------', formatter.output[2]
  end

  def test_adds_colored_title
    formatter = Formatter.new
    formatter.add_title(title: 'Info Title', add_color: true)
    color_title = "\e[#{COLOR_CODE[OUTPUT_COLORS[:title]]}mInfo Title\e[0m"
    assert_match color_title, formatter.output[1]
  end

  def test_adds_row
    formatter = Formatter.new
    descriptor = %w[m n o p]
    row = ['a', 1, 'b', 2]
    formatter.add_row(row: row, descriptor: descriptor)
    assert_equal 'a 1 n b 2 ps', formatter.output[0]
  end

  def test_adds_colored_row
    formatter = Formatter.new
    descriptor = %w[thing thing]
    row = [1, 2]
    formatter.add_row(row: row, descriptor: descriptor, add_color: true)
    color_item1 = "\e[#{COLOR_CODE[OUTPUT_COLORS[:columns][0]]}m1 thing\e[0m"
    color_item2 = "\e[#{COLOR_CODE[OUTPUT_COLORS[:columns][1]]}m2 things\e[0m"
    assert_equal "#{color_item1} #{color_item2}", formatter.output[0]
  end

  def test_adds_descriptor_to_integer_when_1
    formatter = Formatter.new
    assert_equal '1 thing', formatter.add_descriptor(1, 'thing')
  end

  def test_adds_descriptor_to_integer_when_greater_than_1
    formatter = Formatter.new
    assert_equal '2 things', formatter.add_descriptor(2, 'thing')
  end

  def test_does_not_add_descriptor_to_non_integer
    formatter = Formatter.new
    assert_equal 'a', formatter.add_descriptor('a', 'thing')
  end

  def test_format_info_adds_title_to_output
    assert_equal TEST_OUTPUT_1[1],
                 Formatter.new.format_info(view_info: TEST_INFO_1)[1]
  end

  def test_format_info_adds_line_breaks_to_output
    assert_equal TEST_OUTPUT_1[0],
                 Formatter.new.format_info(view_info: TEST_INFO_1)[0]
    assert_equal TEST_OUTPUT_1[2],
                 Formatter.new.format_info(view_info: TEST_INFO_1)[2]
  end

  def test_format_info_sorts_list_alphabetically_to_when_item_count_the_same
    assert_equal TEST_OUTPUT_1[3],
                 Formatter.new.format_info(view_info: TEST_INFO_1)[3]
    assert_equal TEST_OUTPUT_1[4],
                 Formatter.new.format_info(view_info: TEST_INFO_1)[4]
    assert_equal TEST_OUTPUT_1[5],
                 Formatter.new.format_info(view_info: TEST_INFO_1)[5]
  end

  def test_format_info_sorts_list_to_by_item_count
    assert_equal TEST_OUTPUT_2[3],
                 Formatter.new.format_info(view_info: TEST_INFO_2)[3]
    assert_equal TEST_OUTPUT_2[4],
                 Formatter.new.format_info(view_info: TEST_INFO_2)[4]
    assert_equal TEST_OUTPUT_2[5],
                 Formatter.new.format_info(view_info: TEST_INFO_2)[5]
  end

  def test_format_info_adds_item_description_to_for_one_item
    assert_equal TEST_OUTPUT_3[4],
                 Formatter.new.format_info(view_info: TEST_INFO_3)[4]
  end

  def test_format_info_adds_item_description_to_for_greater_than_one_item
    assert_equal TEST_OUTPUT_3[3],
                 Formatter.new.format_info(view_info: TEST_INFO_3)[3]
  end

  def test_format_log_info_shows_log_info
    assert_equal TEST_INFO_OUTPUT_1,
                 Formatter.new.format_log_info(log_info: TEST_LOG_INFO_1)
  end

  def test_format_log_info_shows_multiple_files
    assert_equal TEST_INFO_OUTPUT_2,
                 Formatter.new.format_log_info(log_info: TEST_LOG_INFO_2)
  end

  def test_formats_test_warnings_in_quiet_mode
    warnings = WarningHandler.new(warnings: TEST_WARNINGS_1)
                             .store_warning_info(warning_info: LOG_WARNINGS)
                             .warnings_summary
    assert_equal TEST_WARNING_QUIET_1,
                 Formatter.new.format_minimal_warnings(warnings: warnings)
  end

  def test_formats_normal_warnings
    warnings = WarningHandler.new(warnings: TEST_WARNINGS_1)
                             .store_warning_info(warning_info: LOG_WARNINGS)
                             .warnings_summary
    assert_equal TEST_WARNING_STD_1,
                 Formatter.new.format_normal_warnings(warnings: warnings)
  end

  def test_formats_full_warnings
    warnings = WarningHandler.new(warnings: TEST_WARNINGS_1)
                             .store_warning_info(warning_info: LOG_WARNINGS)
                             .warnings_summary
    assert_equal TEST_WARNING_VERBOSE_1,
                 Formatter.new.format_full_warnings(warnings: warnings)
  end

  def test_format_options
    formatted_options = Formatter.new.format_options(options: ALL_OPTIONS_ON)
    assert_match (/verbose: true/), formatted_options
    assert_match (/quiet: true/), formatted_options
    assert_match (/highlighting: true/), formatted_options
    assert_match (/file list: test1.log, test2.log, test3.log/),
                 formatted_options
    assert_match (/output format: text/), formatted_options
    assert_match (/timestamp: true/), formatted_options
    assert_match (/ip validation: ip4 address/), formatted_options
    assert_match (/path validation: true/), formatted_options
    assert_match (/ignore invalid logs: true/), formatted_options
    assert_match (/path validation: true/), formatted_options
    assert_match (/page visits: true/), formatted_options
    assert_match (/unique page views: true/), formatted_options
  end

  def test_pluralises_multiple_items
    assert_equal 'things', Formatter.new.pluralise('thing', 5)
  end

  def test_doesnt_pluralise_single_items
    assert_equal 'thing', Formatter.new.pluralise('thing', 1)
  end
end
