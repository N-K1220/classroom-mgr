require_relative 'timetable_information'

class TimetableInformationRepository
    def initialize(timetable_informations: [])
        @timetable_informations = []

        unless timetable_informations.is_a?(Array)
            raise ArgumentError, "timetable_informations must be an Array"
        end

        replace_all(timetable_informations)
    end

    def add(timetable_information)
        unless timetable_information.is_a?(TimetableInformation)
            raise ArgumentError, "timetable_information must be an instance of TimetableInformation"
        end

        @timetable_informations << timetable_information
    end

    def remove(timetable_information)
        unless timetable_information.is_a?(TimetableInformation)
            raise ArgumentError, "timetable_information must be an instance of TimetableInformation"
        end

        @timetable_informations.delete(timetable_information)
    end

    def replace_all(timetable_informations)
        timetable_informations.map do |info|
            unless info.is_a?(TimetableInformation)
                raise ArgumentError, "All elements must be instances of TimetableInformation"
            end
        end

        @timetable_informations = timetable_informations.dup
    end

    def find_all
        @timetable_informations.dup
    end
end