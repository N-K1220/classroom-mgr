require 'date'

class TimetableInformation < Data.define(:subject, :term, :day_of_the_week, :periods, :user, :room_name)
    def initialize(subject:, term:, day_of_the_week:, periods:, user:, room_name:)
        unless subject.is_a?(String)
            raise ArgumentError, "subject must be a String"
        end
        unless term.is_a?(Integer)
            raise ArgumentError, "term must be an Integer"
        end
        unless day_of_the_week.is_a?(Symbol)
            raise ArgumentError, "day_of_the_week must be a Symbol"
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

        super(subject: subject, term: term, day_of_the_week: day_of_the_week, periods: periods, user: user, room_name: room_name)
    end
end