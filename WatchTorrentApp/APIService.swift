//
//  APIService.swift
//  WatchTorrent Watch App
//
//  Created by Aayush Pokharel on 2022-12-19.
//

import Foundation

enum APIService {
    static func fetch<T: Decodable>(from url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)

        let decoder = JSONDecoder()
        let result = try decoder.decode(T.self, from: data)

        return result
    }

    static func fetchTorrents() async throws -> [TorrentModel] {
        return try await APIService
            .fetch(from: Constants.torrentsURL)
    }
}
