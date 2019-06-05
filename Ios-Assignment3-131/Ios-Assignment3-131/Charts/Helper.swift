//
//  Helper.swift
//  Ios-Assignment3-131
//
//  Created by MorningStar on 2019/6/2.
//

import Foundation
import UIKit

struct Helper {
    // 最后一个月字符串日期
    static func lastMonthDateStr() -> String {
        var calendar = Calendar.autoupdatingCurrent
        calendar.firstWeekday = 1
        var dateComponents = calendar.dateComponents(in: .current, from: Date())

        guard let month = dateComponents.month, let day = dateComponents.day else {
            fatalError("Somethings about date oops like wrong")
        }

        dateComponents.setValue(month - 1, for: .month)
        dateComponents.setValue(day + 1, for: .day)

        guard let minDate = calendar.date(from: dateComponents) else {
            fatalError("Somethings about date oops like wrong")
        }

        return getString(from: minDate)
    }

    // 日期格式
    static func getString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    // 计算最后一个月的每一天，并转换成固定格式存起
    static func getLastMonthString(from day: Int) -> [String] {
        var calendar = Calendar.autoupdatingCurrent
        calendar.firstWeekday = 1
        var dateComponents = calendar.dateComponents(in: .current, from: Date())

        guard let day = dateComponents.day else {
            return []
        }

        dateComponents.setValue(day - day, for: .day)

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

    static var customDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    }()
}

extension UIStoryboard {
    static func instantiate<T: UIViewController>(_ name: String,
                                                 with viewController: T.Type) -> T {
        let identifier = className(viewController)
        let bundle = Bundle(for: viewController.self)
        return UIStoryboard(name: name, bundle: bundle)
            .instantiateViewController(withIdentifier: identifier) as! T
    }
}

func className<T>(_ className: T.Type) -> String {
    return String(describing: className).components(separatedBy: ".").last ?? ""
}

func printLog(_ message: Any...,
    file: String = #file,
    method: String = #function,
    line: Int = #line)
{
    #if DEBUG
    if message.count <= 1 {
        print(message.first ?? "printLog failed")
    } else {
        print("\n\(file.components(separatedBy: "/").last ?? "no file name")[\(line)], \(method): \n", message)
    }
    #endif
}
