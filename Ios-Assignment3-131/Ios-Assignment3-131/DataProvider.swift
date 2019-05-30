//
//  DataProvider.swift
//  Ios-Assignment3-131
//
//  Created by MorningStar on 2019/5/22.
//

import Foundation

class DataProvider {
    static func getLastThreeMonthDateStr() -> [String] {
        var calendar = Calendar.autoupdatingCurrent
        calendar.firstWeekday = 1
        var dateComponents = calendar.dateComponents(in: .current, from: Date())

        guard let month = dateComponents.month else {
            return []
        }

        dateComponents.setValue(month - 3, for: .month)

        var currentDateComponents = calendar.dateComponents(in: .current, from: Date())
        guard let minDate = calendar.date(from: dateComponents),
            let totalDays = calendar.dateComponents([.day], from: minDate, to: Date()).day,
            let currentDay = currentDateComponents.day else {
                return []
        }

        var dateStr: [String] = []
        for index in 0..<totalDays {
            currentDateComponents.setValue(currentDay - index, for: .day)
            let date = calendar.date(from: currentDateComponents)!
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let str = formatter.string(from: date)
            dateStr.append(str)
        }
        return dateStr
    }

    static func getCoin() -> [String] {
        return ["Bitcoin", "Ethereum"]
    }
}
