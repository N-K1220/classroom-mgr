require 'date'

class ReservationInformation < Data.define(:date, :subject, :periods, :user, :room_name)
    def initialize(date:, subject:, periods:, user:, room_name:)
        unless date.is_a?(Date)
            raise ArgumentError, "date must be a Date object"
        end
        unless subject.is_a?(String)
            raise ArgumentError, "subject must be a String"
        end
        unless periods.is_a?(Array) && periods.all? { |p| p.is_a?(Symbol) }
            raise ArgumentError, "periods must be an Array of Symbols"
        end
        unless user.is_a?(String)
            raise ArgumentError, "user must be a String"
        end
        unless room_name.is_a?(String)
            raise ArgumentError, "room_name must be a String"
        end

        super(date: date, subject: subject, periods: periods, user: user, room_name: room_name)
    end
end