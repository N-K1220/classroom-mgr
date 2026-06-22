require_relative 'reservation_information'

class ReservationInformationRepository
    def initialize(reservation_informations: [])
        @reservation_informations = []

        unless reservation_informations.is_a?(Array)
            raise ArgumentError, "reservation_informations must be an Array"
        end

        replace_all(reservation_informations)
    end

    def add(reservation_information)
        unless reservation_information.is_a?(ReservationInformation)
            raise ArgumentError, "reservation_information must be an instance of ReservationInformation"
        end

        @reservation_informations << reservation_information
    end

    def remove(reservation_information)
        unless reservation_information.is_a?(ReservationInformation)
            raise ArgumentError, "reservation_information must be an instance of ReservationInformation"
        end

        @reservation_informations.delete(reservation_information)
    end

    def replace_all(reservation_informations)
        reservation_informations.map do |info|
            unless info.is_a?(ReservationInformation)
                raise ArgumentError, "All elements must be instances of ReservationInformation"
            end
        end

        @reservation_informations = reservation_informations.dup
    end

    def find_all
        @reservation_informations.dup
    end
end