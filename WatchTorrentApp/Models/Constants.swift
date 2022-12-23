//
//  Constants.swift
//  WatchTorrent Watch App
//
//  Created by Aayush Pokharel on 2022-12-19.
//

import Foundation

enum Constants {
    // API: Using PiedPiper as middle man to my home server
    //  https://github.com/Aayush9029/PiedPiper

    // YES a PiedPiper
    // static let piedPiper = true
    // static let serverIP = "0.0.0.0"
    // static let serverPORT = 4444
    // static let torrentKey = "com-aayush-opensource-watchtorrent-torrents-url-key-for-piedpiper"

    // static let remoteServer = "http://\(serverIP):\(serverPORT)/api/v1/nodes/"
    // static let torrentsURL = URL(string: "\(remoteServer)/\(torrentKey)")!

    // NOT a PiedPiper
    static let piedPiper = false
    static let torrentsURL = URL(string: "http://yourserver:port/api/v2/torrents/info")!
}
