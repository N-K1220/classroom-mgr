require_relative '../lib/lecture_room_management_information'
require 'date'
require 'minitest/autorun'

class LectureRoomManagementInformationTest < Minitest::Test
    def setup
        @valid_date = Date.new(2024, 6, 1)
        @valid_day_of_the_week = :mon
        @valid_term = 1
        @valid_periods = [:p1, :p2]
        @valid_room_name = "Room A"
        @valid_subject = "Mathematics"
        @valid_user = "John Doe"
        @valid_comment = "No comments"
    end

    def test_valid_initialization
        info = LectureRoomManagementInformation.new(
            date: @valid_date,
            day_of_the_week: @valid_day_of_the_week,
            term: @valid_term,
            periods: @valid_periods,
            room_name: @valid_room_name,
            subject: @valid_subject,
            user: @valid_user,
            comment: @valid_comment
        )
        assert_equal @valid_date, info.date
        assert_equal @valid_day_of_the_week, info.day_of_the_week
        assert_equal @valid_term, info.term
        assert_equal @valid_periods, info.periods
        assert_equal @valid_room_name, info.room_name
        assert_equal @valid_subject, info.subject
        assert_equal @valid_user, info.user
        assert_equal @valid_comment, info.comment
    end

    def test_invalid_date
        assert_raises(ArgumentError) do
            LectureRoomManagementInformation.new(
                date: "2024-06-01",
                day_of_the_week: @valid_day_of_the_week,
                term: @valid_term,
                periods: @valid_periods,
                room_name: @valid_room_name,
                subject: @valid_subject,
                user: @valid_user,
                comment: @valid_comment
            )
        end
    end

    def test_invalid_day_of_the_week
        assert_raises(ArgumentError) do
            LectureRoomManagementInformation.new(
                date: @valid_date,
                day_of_the_week: "Monday",
                term: @valid_term,
                periods: @valid_periods,
                room_name: @valid_room_name,
                subject: @valid_subject,
                user: @valid_user,
                comment: @valid_comment
            )
        end
    end

    def test_invalid_term
        assert_raises(ArgumentError) do
            LectureRoomManagementInformation.new(
                date: @valid_date,
                day_of_the_week: @valid_day_of_the_week,
                term: "First Term",
                periods: @valid_periods,
                room_name: @valid_room_name,
                subject: @valid_subject,
                user: @valid_user,
                comment: @valid_comment
            )
        end
    end

    def test_invalid_periods
        assert_raises(ArgumentError) do
            LectureRoomManagementInformation.new(
                date: @valid_date,
                day_of_the_week: @valid_day_of_the_week,
                term: @valid_term,
                periods: [:p1, "p2"],
                room_name: @valid_room_name,
                subject: @valid_subject,
                user: @valid_user,
                comment: @valid_comment
            )
        end
    end

    def test_invalid_room_name
        assert_raises(ArgumentError) do
            LectureRoomManagementInformation.new(
                date: @valid_date,
                day_of_the_week: @valid_day_of_the_week,
                term: @valid_term,
                periods: @valid_periods,
                room_name: 123,
                subject: @valid_subject,
                user: @valid_user,
                comment: @valid_comment
            )
        end
    end

    def test_invalid_subject
        assert_raises(ArgumentError) do
            LectureRoomManagementInformation.new(
                date: @valid_date,
                day_of_the_week: @valid_day_of_the_week,
                term: @valid_term,
                periods: @valid_periods,
                room_name: @valid_room_name,
                subject: 123,
                user: @valid_user,
                comment: @valid_comment
            )
        end
    end

    def test_invalid_user
        assert_raises(ArgumentError) do
            LectureRoomManagementInformation.new(
                date: @valid_date,
                day_of_the_week: @valid_day_of_the_week,
                term: @valid_term,
                periods: @valid_periods,
                room_name: @valid_room_name,
                subject: @valid_subject,
                user: 123,
                comment: @valid_comment
            )
        end
    end

    def test_invalid_comment
        assert_raises(ArgumentError) do
            LectureRoomManagementInformation.new(
                date: @valid_date,
                day_of_the_week: @valid_day_of_the_week,
                term: @valid_term,
                periods: @valid_periods,
                room_name: @valid_room_name,
                subject: @valid_subject,
                user: @valid_user,
                comment: 123
            )
        end
    end
end

    