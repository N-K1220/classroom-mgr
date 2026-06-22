require_relative 'managed_lecture_room_information'

class ManagedLectureRoomInformationRepository
    def initialize(managed_lecture_room_informations: [])
        @managed_lecture_room_informations = []

        unless managed_lecture_room_informations.is_a?(Array)
            raise ArgumentError, "managed_lecture_room_informations must be an Array"
        end

        replace_all(managed_lecture_room_informations)
    end

    def add(managed_lecture_room_information)
        unless managed_lecture_room_information.is_a?(ManagedLectureRoomInformation)
            raise ArgumentError, "managed_lecture_room_information must be an instance of ManagedLectureRoomInformation"
        end

        @managed_lecture_room_informations << managed_lecture_room_information
    end

    def remove(managed_lecture_room_information)
        unless managed_lecture_room_information.is_a?(ManagedLectureRoomInformation)
            raise ArgumentError, "managed_lecture_room_information must be an instance of ManagedLectureRoomInformation"
        end

        @managed_lecture_room_informations.delete(managed_lecture_room_information)
    end

    def replace_all(managed_lecture_room_informations)
        managed_lecture_room_informations.map do |info|
            unless info.is_a?(ManagedLectureRoomInformation)
                raise ArgumentError, "All elements must be instances of ManagedLectureRoomInformation"
            end
        end

        @managed_lecture_room_informations = managed_lecture_room_informations.dup
    end

    def find_all
        @managed_lecture_room_informations.dup
    end
end