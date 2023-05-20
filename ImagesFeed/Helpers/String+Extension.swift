//
//  String+Extension.swift
//  ImagesFeed
//
//  Created by Вадим Кузьмин on 13.05.2023.
//

import Foundation

private let dateTimeDefaultFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    return dateFormatter
}()

extension String {
    var stringToDate: Date? {
        if let date = dateTimeDefaultFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
