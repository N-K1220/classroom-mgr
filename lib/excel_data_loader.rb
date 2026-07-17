require 'rubyXL'
require 'zip'

class ExcelDataLoader
  class InvalidExcelFileError < StandardError; end

  def self.load_xlsx_file(directory_path)
    xlsx_files = Dir.glob(File.join(directory_path, '*.xlsx'))

    if xlsx_files.length != 1
      return nil
    end

    xlsx_file = xlsx_files[0]

    begin
      workbook = with_exclusive_lock(xlsx_file) do
        RubyXL::Parser.parse(xlsx_file)
      end
    rescue Zip::Error => e
      raise InvalidExcelFileError, "#{xlsx_file} は有効なxlsxファイルではありません: #{e.message}"
    end

    return workbook
  end

  def self.with_exclusive_lock(file_path)
    File.open("#{file_path}.lock", 'a+b') do |lock_file|
      lock_file.flock(File::LOCK_EX)

      begin
        yield
      ensure
        lock_file.flock(File::LOCK_UN)
      end
    end
  end
  private_class_method :with_exclusive_lock

  def self.load_academic_calendar_xlsx_file(directory_name)
    unless directory_name.is_a?(String)
      raise TypeError, 'directory_name must be a String.'
    end

    load_xlsx_file("data/#{directory_name}/学年暦")
  end

  def self.load_timetable_xlsx_file(directory_name)
    unless directory_name.is_a?(String)
      raise TypeError, 'directory_name must be a String.'
    end

    load_xlsx_file("data/#{directory_name}/時間割")
  end

  def self.load_reservation_xlsx_file(directory_name)
    unless directory_name.is_a?(String)
      raise TypeError, 'directory_name must be a String.'
    end

    load_xlsx_file("data/#{directory_name}/予約")
  end

  def self.load_managed_lecture_room_xlsx_file
    load_xlsx_file("data/管理対象講義室")
  end
end # class ExcelDataLoader
