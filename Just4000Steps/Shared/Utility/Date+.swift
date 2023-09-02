//
//  Date+.swift
//  Just4000Steps
//
//  Created by 山田　天星 on 2023/08/13.
//

import Foundation

extension Date {
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601)
            .date(from: Calendar(identifier: .iso8601)
                .dateComponents([.yearForWeekOfYear, .weekOfYear],
                                from: Date()
                               )
            )!
    }
}
