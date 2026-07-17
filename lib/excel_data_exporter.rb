require 'fileutils'
require 'rubyXL'

class ExcelDataExporter
  OUTPUT_DIRECTORY = File.expand_path('../output', __dir__)

  def initialize
  end

  def export(workbook, file_name)
    unless workbook.is_a?(RubyXL::Workbook)
      raise TypeError, 'workbook must be a RubyXL::Workbook.'
    end

    unless file_name.is_a?(String)
      raise TypeError, 'file_name must be a String.'
    end

    FileUtils.mkdir_p(OUTPUT_DIRECTORY)

    output_file_path = File.join(OUTPUT_DIRECTORY, "#{file_name}.xlsx")

    with_exclusive_lock(output_file_path) do
      workbook.write(output_file_path)
    end
  end

  private

  def with_exclusive_lock(file_path)
    File.open("#{file_path}.lock", 'a+b') do |lock_file|
      lock_file.flock(File::LOCK_EX)

      begin
        yield
      ensure
        lock_file.flock(File::LOCK_UN)
      end
    end
  end
end
