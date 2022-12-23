//
//  Constants.swift
//  WatchTorrent Watch App
//
//  Created by Aayush Pokharel on 2022-12-19.
//

import Foundation

struct Constants {
    // API: Using PiedPiper as middle man to my home server
    //  https://github.com/Aayush9029/PiedPiper

    // change this
    static let serverIP = "0.0.0.0"
    static let serverPORT = 4444

    // this can be anything, longer and whacky-er the better
    static let torrentKey = "com-aayush-opensource-watchtorrent-torrents-url-key-for-piedpiper"

    static let remoteServer = "http://\(serverIP):\(serverPORT)/api/v1/nodes/"
    static let torrentsURL = URL(string: "\(remoteServer)/\(torrentKey)")!
}
