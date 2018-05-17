//
//  Extensions.swift
//  MeteoOne
//
//  Created by Valentinas Mirosnicenko on 5/17/18.
//  Copyright © 2018 Valentinas Mirosnicenko. All rights reserved.
//

import Foundation

extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
