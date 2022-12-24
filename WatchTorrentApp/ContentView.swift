//
//  ContentView.swift
//  WatchTorrent Watch App
//
//  Created by Aayush Pokharel on 2022-12-19.
//

import SwiftUI

struct ContentView: View {
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    @State private var torrents: [TorrentModel]?

    var body: some View {
        VStack {
            if let torrents {
                if !torrents.isEmpty {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            ForEach(torrents) { torrent in
                                SingleTorrentRow(torrent: torrent)
                            }
                        }
                        .padding(.horizontal)
                    }
                } else {
                    BadgeView(icon: "tray.and.arrow.down.fill", text: "Empty Torrents", value: "Torrent feed is empty.")
                }
            } else {
                BadgeView(icon: "wifi.router.fill", text: "Connecting to", value: Constants.serverIP)
            }
        }.task {
            Task {
                if Constants.piedPiper {
                    torrents = await PiedPiperModel.fetch()
                } else {
                    torrents = TorrentModel.example()
                }
            }
        }
        .onReceive(timer) { _ in
            Task {
                if Constants.piedPiper {
                    torrents = await PiedPiperModel.fetch()
                } else {
                    torrents = await TorrentModel.fetch()
                }
            }
        }
    }
}

struct ContextMenuButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    init(_ title: String, _ icon: String, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            Label(title, systemImage: icon)
                .symbolVariant(.fill)
        }
    }
}

struct Previews_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
