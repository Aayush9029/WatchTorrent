//
//  TorrentModel.swift
//  WatchTorrent Watch App
//
//  Created by Aayush Pokharel on 2022-12-19.
//

import Foundation

// MARK: - SingleTorrent

// https://github.com/qbittorrent/qBittorrent/wiki/WebUI-API-(qBittorrent-4.1)#get-torrent-list

struct TorrentModel: Codable, Identifiable {
    var id: String { magnetURI }
    let addedOn, amountLeft: Int64
    let autoTmm: Bool
    let availability: Double
    let category: String
    let completed: Int64
    let completionOn: Int64
    let contentPath: String
    let dlLimit, dlspeed: Int64
    let downloadPath: String
    let downloaded, downloadedSession, eta: Int64
    let fLPiecePrio, forceStart: Bool
    let hash, infohashV1, infohashV2: String
    let lastActivity: Int64
    let magnetURI: String
    let maxRatio, maxSeedingTime: Int64
    let name: String
    let numComplete, numIncomplete, numLeechs, numSeeds: Int64
    let priority: Int64
    let progress: Double
    let ratio: Double
    let ratioLimit: Int64
    let savePath: String
    let seedingTime, seedingTimeLimit, seenComplete: Int64
    let seqDL: Bool
    let size: Int64
    let state: TorrentState
    let superSeeding: Bool
    let tags: String
    let timeActive, totalSize: Int64
    let tracker: String
    let trackersCount, upLimit, uploaded, uploadedSession: Int64
    let upspeed: Int64

    enum CodingKeys: String, CodingKey {
        case addedOn = "added_on"
        case amountLeft = "amount_left"
        case autoTmm = "auto_tmm"
        case availability, category, completed
        case completionOn = "completion_on"
        case contentPath = "content_path"
        case dlLimit = "dl_limit"
        case dlspeed
        case downloadPath = "download_path"
        case downloaded
        case downloadedSession = "downloaded_session"
        case eta
        case fLPiecePrio = "f_l_piece_prio"
        case forceStart = "force_start"
        case hash
        case infohashV1 = "infohash_v1"
        case infohashV2 = "infohash_v2"
        case lastActivity = "last_activity"
        case magnetURI = "magnet_uri"
        case maxRatio = "max_ratio"
        case maxSeedingTime = "max_seeding_time"
        case name
        case numComplete = "num_complete"
        case numIncomplete = "num_incomplete"
        case numLeechs = "num_leechs"
        case numSeeds = "num_seeds"
        case priority, progress, ratio
        case ratioLimit = "ratio_limit"
        case savePath = "save_path"
        case seedingTime = "seeding_time"
        case seedingTimeLimit = "seeding_time_limit"
        case seenComplete = "seen_complete"
        case seqDL = "seq_dl"
        case size, state
        case superSeeding = "super_seeding"
        case tags
        case timeActive = "time_active"
        case totalSize = "total_size"
        case tracker
        case trackersCount = "trackers_count"
        case upLimit = "up_limit"
        case uploaded
        case uploadedSession = "uploaded_session"
        case upspeed
    }
}

enum TorrentState: String, Codable {
    case error // Some error occurred, applies to paused torrents
    case missingFiles // Torrent data files is missing
    case uploading // Torrent is being seeded and data is being transferred
    case pausedUP // Torrent is paused and has finished downloading
    case queuedUP // Queuing is enabled and torrent is queued for upload
    case stalledUP // Torrent is being seeded, but no connection were made
    case checkingUP // Torrent has finished downloading and is being checked
    case forcedUP // Torrent is forced to uploading and ignore queue limit
    case allocating // Torrent is allocating disk space for download
    case downloading // Torrent is being downloaded and data is being transferred
    case metaDL // Torrent has just started downloading and is fetching metadata
    case pausedDL // Torrent is paused and has NOT finished downloading
    case queuedDL // Queuing is enabled and torrent is queued for download
    case stalledDL // Torrent is being downloaded, but no connection were made
    case checkingDL // Same as checkingUP, but torrent has NOT finished downloading
    case forcedDL // Torrent is forced to downloading to ignore queue limit
    case checkingResumeData // Checking resume data on qBt startup
    case moving // Torrent is moving to another location
    case unknown // Unknown status
}

extension TorrentModel {
    static func example() -> [TorrentModel]? {
        let data = readLocalJSONFile(forName: "torrent")!
        return try? JSONDecoder().decode([TorrentModel].self, from: data)
    }

    static func fetch() async -> [TorrentModel]? {
        do {
            let (data, _) = try await URLSession.shared.data(from: Constants.torrentsURL)
            return try JSONDecoder().decode([TorrentModel].self, from: data)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print(String(describing: error))
        }
        return nil
    }
}

// MARK: PiedPiper Model

struct PiedPiperModel: Codable {
    let data: String
}

extension PiedPiperModel {
    static func example() async -> [TorrentModel]? {
        let data = readLocalJSONFile(forName: "piedpiper")!
        let ppModel = try? JSONDecoder().decode(PiedPiperModel.self, from: data)
        return await piedToTorrent(pied: ppModel)
    }

    static func fetch() async -> [TorrentModel]? {
        do {
            let (data, _) = try await URLSession.shared.data(from: Constants.torrentsURL)
            let ppModel = try JSONDecoder().decode(PiedPiperModel.self, from: data)
            return await piedToTorrent(pied: ppModel)

        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print(String(describing: error))
        }
        return nil
    }

    static func piedToTorrent(pied: PiedPiperModel?) async -> [TorrentModel]? {
        if let data = pied?.data {
            // curl -X GET http://localserver:port/api/v2/torrents/info | base64
            // Decoding for client side (personal choice)
            if let b64D1 = data.base64Decoded() {
                // Decoding for server side (server choice)
                if let b64D2 = b64D1.base64Decoded() {
                    if let b64Data = b64D2.data(using: .utf8) {
                        do {
                            return try JSONDecoder().decode([TorrentModel].self, from: b64Data)
                        } catch let DecodingError.valueNotFound(value, context) {
                            print("Value '\(value)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch let DecodingError.typeMismatch(type, context) {
                            print("Type '\(type)' mismatch:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch {
                            print(String(describing: error))
                        }
                    }
                }
            }
        }
        return nil
    }
}
