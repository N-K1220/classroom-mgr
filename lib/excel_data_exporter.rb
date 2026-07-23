require 'fileutils'
require 'rubyXL'
require_relative 'excel_data_loader' # ApplicationPathクラスを利用するため

class ExcelDataExporter
  # ApplicationPathと同じ，アプリケーションルート直下のoutputを公開する。
  OUTPUT_DIRECTORY = ApplicationPath::OUTPUT_DIRECTORY

  def initialize
  end

  def export(workbook, file_name)
    unless workbook.is_a?(RubyXL::Workbook)
      raise TypeError, 'workbook must be a RubyXL::Workbook.'
    end

    unless file_name.is_a?(String)
      raise TypeError, 'file_name must be a String.'
    end

    # 出力先を検証してから，Excelファイル自体をロックして書き込む。
    output_file_path = ApplicationPath.output_file_path(file_name, create_directory: true)

    write_with_exclusive_lock(workbook, output_file_path)
  rescue Errno::ELOOP
    raise ApplicationPath::InvalidPathError, 'output file must not be a symbolic link.'
  end

  private

  def write_with_exclusive_lock(workbook, file_path)
    # ファイルを空にする前にxlsx全体を生成し、生成失敗時は既存ファイルを維持する。
    workbook_stream = workbook.stream

    with_exclusive_lock(file_path, File::RDWR | File::CREAT) do |file|
      file.rewind
      file.truncate(0)
      IO.copy_stream(workbook_stream, file)
    end
  end

  def with_exclusive_lock(file_path, open_flags)
    open_flags |= File::NOFOLLOW if File.const_defined?(:NOFOLLOW)

    File.open(file_path, open_flags, 0o600) do |file|
      file.flock(File::LOCK_EX)
      yield file
    ensure
      file.flock(File::LOCK_UN)
    end
  end
end
