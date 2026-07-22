require_relative '../test_helper'
require 'tmpdir'
require_relative '../../lib/excel_data_loader'

class ExcelDataLoaderTest < Minitest::Test
  def test_loads_excel_file_without_creating_a_lock_file
    Dir.mktmpdir do |directory|
      file_path = File.join(directory, 'workbook.xlsx')
      workbook = RubyXL::Workbook.new
      workbook[0].add_cell(0, 0, 'direct lock')
      workbook.write(file_path)

      loaded_workbook = Dir.chdir(directory) do
        ExcelDataLoader.load_xlsx_file('.')
      end

      assert_equal 'direct lock', loaded_workbook[0][0][0].value
      refute File.exist?("#{file_path}.lock")
    end
  end
end
