//
//  DayDate.swift
//  Pods
//
//  Created by Reinert Lemmens on 7/26/17.
//
//

import Foundation
import UIKit

class DayDate: Hashable, Comparable, CustomStringConvertible {

    let day: Int
    let month: Int
    let year: Int
    let era: Int
    static let formats = ["E d MMM yyyy", "E d MMM", "d MMM"]

    public var description: String {
        return "\(day)-\(month)-\(year)-\(era)"
    }

    lazy var dateObj: Date = {
        var dateComps = self.dateComponents
        dateComps.hour = 12
        return Calendar.current.date(from: dateComps)!
    }()

    lazy var hashValue: Int = {
        return "\(self.day)-\(self.month)-\(self.year)-\(self.era)".hashValue
    }()

    lazy var largeString: String = {
        return self.getString(forMode: 0)
    }()

    lazy var defaultString: String = {
        return self.getString(forMode: 1)
    }()

    lazy var smallString: String = {
        return self.getString(forMode: 2)
    }()

    lazy var dayInYear: Int = {
        return self.dateObj.getDayOfYear()
    }()

    private lazy var dateComponents: DateComponents = {
        var dateComps: DateComponents = DateComponents()
        dateComps.day = self.day
        dateComps.month = self.month
        dateComps.year = self.year
        dateComps.era = self.era
        return dateComps
    }()

    static var today: DayDate {
        return DayDate(date: Date())
    }

    init(day: Int, month: Int, year: Int, era: Int) {
        self.day = day
        self.month = month
        self.year = year
        self.era = era
    }

    init(date: Date) {
        let cal = Calendar.current
        self.day = cal.component(.day, from: date)
        self.month = cal.component(.month, from: date)
        self.year = cal.component(.year, from: date)
        self.era = cal.component(.era, from: date)
    }

    init() {
        self.day = -1
        self.month = -1
        self.year = -1
        self.era = -1
    }

    static func == (lhs: DayDate, rhs: DayDate) -> Bool {
        return lhs.day == rhs.day && lhs.month == rhs.month && lhs.year == rhs.year && lhs.era == rhs.era
    }

    static func < (lhs: DayDate, rhs: DayDate) -> Bool {
        if lhs.era == rhs.era {
            if lhs.year == rhs.year {
                if lhs.month == rhs.month {
                    if lhs.day == rhs.day {
                        return false
                    } else { return lhs.day < rhs.day }
                } else { return lhs.month < rhs.month }
            } else { return lhs.year < rhs.year }
        } else { return lhs.era < rhs.era }
    }

    func getString(forMode mode: Int) -> String {
        let df = DateFormatter()
        df.dateFormat = DayDate.formats[mode]
        return df.string(from: self.dateObj)
    }

    func hasPassed() -> Bool {
        return self <= DayDate.today
    }

    func isToday() -> Bool {
        return self == DayDate.today
    }

    func isWeekend() -> Bool {
        let cal = Calendar.current
        let weekDay = cal.component(.weekday, from: dateObj)
        return (weekDay == 1 || weekDay == 7)
    }

    func getDateWithTime(hours: Int, minutes: Int, seconds: Int) -> Date {
        var comps = self.dateComponents
        comps.hour = hours
        comps.minute = minutes
        comps.second = seconds
        return Calendar.current.date(from: comps)!
    }

    func getDayDateMonday() -> DayDate {
        var cal = Calendar.current
        cal.firstWeekday = 2
        let comps = cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self.dateObj)
        return DayDate(date: cal.date(from: comps)!)
    }

    func getDayDateWith(daysAdded days: Int) -> DayDate {
        return DayDate(date: Calendar.current.date(byAdding: .day, value: days, to: self.dateObj)!)
    }
}
