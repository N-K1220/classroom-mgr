require 'date'
require 'rubyXL'

class AcademicYearConverter
  def self.academic_year_and_month_to_calendar_year(academic_year, month)
    unless academic_year.is_a?(Integer)
      raise TypeError, 'academic_year must be an Integer.'
    end

    unless month.is_a?(Integer)
      raise TypeError, 'month must be an Integer.'
    end

    return month >= 4 ? academic_year : academic_year + 1
  end


  def self.date_to_academic_year(date)
    unless date.is_a?(Date)
      raise TypeError, 'date must be a Date.'
    end

    return date.month >= 4 ? date.year : date.year - 1
  end
end
