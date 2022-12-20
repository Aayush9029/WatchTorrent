//
//  Constants.swift
//  WatchTorrent Watch App
//
//  Created by Aayush Pokharel on 2022-12-19.
//

import Foundation

struct Constants {
    // BASE URL
    static let ipPort = "192.168.68.141:8080"
    static let server = "http://\(ipPort)/api/v2"

    // API
    static let torrentsURL = URL(string: "\(server)/torrents/info")!

    // actions
    static let action = "\(server)/torrents"
    static let pause = "\(action)/pause?hashes="
    static let resume = "\(action)/resume?hashes="
    static let delete = "\(action))/delete?hashes="

    static func addHashes(hashes: [String], base: String) -> URL {
        var baseString = base
        baseString += hashes.joined(separator: "|")
        return URL(string: baseString)!
    }

    static func deleteURL(hashes: [String], storedData: Bool) -> URL {
        return addHashes(hashes: hashes, base: delete).appending(
            queryItems: [URLQueryItem(name: "deleteFiles", value: storedData ? "true" : "false")]
        )
    }
}
