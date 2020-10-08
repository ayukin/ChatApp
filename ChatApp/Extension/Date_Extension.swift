//
//  Date_Extension.swift
//  ChatApp
//
//  Created by 西岡鮎季 on 2020/10/08.
//

import Foundation

extension Date {
    // 出力フォーマット「0000/00/00」
    func formatterDateStyleMedium(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
    // 出力フォーマット「00:00」
    func formatterTimeStyleShort(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }

}
