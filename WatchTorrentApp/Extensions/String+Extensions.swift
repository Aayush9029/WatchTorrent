//
//  String+Extensions.swift
//  WatchTorrentApp
//
//  Created by Aayush Pokharel on 2022-12-22.
//

import Foundation

extension String {
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}
