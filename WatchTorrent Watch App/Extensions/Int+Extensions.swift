//
//  Int+Extensions.swift
//  WatchTorrent Watch App
//
//  Created by Aayush Pokharel on 2022-12-19.
//

import Foundation

extension Int {
    func formattedBytes() -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB, .useTB]
        formatter.countStyle = .binary
        formatter.allowsNonnumericFormatting = false
        return formatter.string(for: self) ?? "0"
    }

    func secondsToHumanReadableString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.year, .day, .hour, .minute]

        let interval = TimeInterval(self)
        return formatter.string(from: interval) ?? ""
    }
}
