require_relative '../test_helper'
require 'rbconfig'
require_relative '../../lib/excel_data_exporter'

class ExcelDataExporterTest < Minitest::Test
  def setup
    @exporter = ExcelDataExporter.new
    @file_name = 'excel_data_exporter_test'
    @output_file_path = File.join(ExcelDataExporter::OUTPUT_DIRECTORY, "#{@file_name}.xlsx")
  end

  def teardown
    File.delete(@output_file_path) if File.exist?(@output_file_path)
  end

  def test_new_returns_excel_data_exporter
    assert_instance_of ExcelDataExporter, ExcelDataExporter.new
  end

  def test_export_workbook
    workbook = RubyXL::Workbook.new
    workbook[0].add_cell(0, 0, 'exported')

    @exporter.export(workbook, @file_name)
    exported_workbook = RubyXL::Parser.parse(@output_file_path)

    assert File.exist?(@output_file_path)
    assert_equal 'exported', exported_workbook[0][0][0].value
    refute File.exist?("#{@output_file_path}.lock")
  end

  def test_export_with_xlsx_extension_locks_the_actual_output_file
    workbook = RubyXL::Workbook.new
    file_name_with_extension = "#{@file_name}.xlsx"

    @exporter.stub(:write_with_exclusive_lock, ->(_workbook, file_path) do
      assert_equal @output_file_path, file_path
    end) do
      @exporter.export(workbook, file_name_with_extension)
    end
  end

  def test_export_validates_output_path_before_acquiring_lock
    workbook = RubyXL::Workbook.new
    write_was_called = false

    @exporter.stub(:write_with_exclusive_lock, ->(*) { write_was_called = true }) do
      ApplicationPath.stub(:output_file_path, ->(*) { raise ApplicationPath::InvalidPathError }) do
        assert_raises(ApplicationPath::InvalidPathError) do
          @exporter.export(workbook, @file_name)
        end
      end
    end

    refute write_was_called
  end

  def test_export_rejects_symbolic_link_output_file
    workbook = RubyXL::Workbook.new

    File.stub(:symlink?, ->(file_path) { file_path == @output_file_path }) do
      assert_raises(ApplicationPath::InvalidPathError) do
        @exporter.export(workbook, @file_name)
      end
    end
  end

  def test_export_converts_output_file_link_follow_error_to_invalid_path_error
    workbook = RubyXL::Workbook.new

    @exporter.stub(:write_with_exclusive_lock, ->(*) { raise Errno::ELOOP }) do
      assert_raises(ApplicationPath::InvalidPathError) do
        @exporter.export(workbook, @file_name)
      end
    end
  end

  def test_invalid_workbook
    assert_raises(TypeError) do
      @exporter.export('not a workbook', @file_name)
    end
  end

  def test_invalid_file_name
    assert_raises(TypeError) do
      @exporter.export(RubyXL::Workbook.new, 123)
    end
  end

  def test_export_lock_on_excel_file_blocks_another_process
    @exporter.send(:with_exclusive_lock, @output_file_path, File::RDWR | File::CREAT) do
      assert_equal 'blocked', lock_status_from_another_process
    end

    assert_equal 'locked', lock_status_from_another_process
  end

  private

  def lock_status_from_another_process
    script = <<~RUBY
      File.open(ARGV[0], 'r+b') do |file|
        puts(file.flock(File::LOCK_EX | File::LOCK_NB) ? 'locked' : 'blocked')
      end
    RUBY

    IO.popen([RbConfig.ruby, '-e', script, @output_file_path], &:read).strip
  end
end
