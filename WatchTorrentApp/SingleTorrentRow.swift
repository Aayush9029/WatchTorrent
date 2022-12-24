//
//  SingleTorrentRow.swift
//  WatchTorrent Watch App
//
//  Created by Aayush Pokharel on 2022-12-19.
//

import SwiftUI

struct SingleTorrentRow: View {
    @State private var showDetails: Bool = false
    let torrent: TorrentModel
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(cleanName())
                    .lineLimit(showDetails ? 4 : 2)
                    .font(.caption2)
                Spacer()
            }

            if showDetails {
                Divider()
                    .opacity(0.5)
                VStack(alignment: .leading) {
                    Group {
                        HStack {
                            Text("\(torrent.totalSize.formattedBytes())/\n\(torrent.downloaded.formattedBytes())")
                            Spacer()
                            Group {
                                VStack {
                                    Image(systemName: "arrow.down")
                                    Text("\(torrent.numLeechs)")
                                }
                                .foregroundStyle(.red)
                                VStack {
                                    Image(systemName: "arrow.up")
                                    Text("\(torrent.numSeeds)")
                                }
                                .foregroundStyle(.green)
                            }
                        }
                    }
                    Group {
                        HStack {
                            Text("\(torrent.dlspeed.formattedBytes())/s")
                                .foregroundStyle(.secondary)
                            Spacer()
                            if torrent.eta < (60 * 60 * 24 * 30 * 12) {
                                Text(torrent.eta.secondsToHumanReadableString())
                                    .lineLimit(1)
                            } else {
                                Text("∞")
                            }
                        }
                    }
                    Divider()
                        .opacity(0.5)
                    if torrent.category != "" {
                        Text("**Category:** \(torrent.category)")
                    }
                    Text("\(torrent.savePath)")
                        .italic()
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .font(.system(size: 12))
        .padding()
        .onTapGesture {
            withAnimation {
                showDetails.toggle()
            }
        }
        .background(
            ZStack {
                getColor()
            }
            .opacity(0.10)
        )
        .cornerRadius(16)
        .overlay(
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        getColor().opacity(0.25),
                        lineWidth: 2
                    )
                RoundedRectangle(cornerRadius: 16)
                    .trim(from: 0, to: CGFloat(torrent.progress))
                    .stroke(
                        getColor(),
                        lineWidth: 2
                    )
            }
            .rotationEffect(Angle(degrees: -180))
        )
    }
}

struct SingleTorrentRow_Previews: PreviewProvider {
    static var previews: some View {
        SingleTorrentRow(torrent: .example()!.first!)
    }
}

extension SingleTorrentRow {
    func getColor() -> Color {
        switch torrent.state {
        case .error:
            return Color.red
        case .uploading:
            return Color.green
        case .metaDL,
             .downloading,
             .checkingResumeData,
             .allocating,
             .forcedDL:
            return Color.teal
        default:
            return Color.gray
        }
    }

    func cleanName() -> String {
        return String(torrent.name.split(separator: "202").first?.replacingOccurrences(of: ".", with: " ") ?? torrent.name)
    }
}
