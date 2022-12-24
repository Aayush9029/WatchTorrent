//
//  BadgeView.swift
//  WatchTorrentApp
//
//  Created by Aayush Pokharel on 2022-12-23.
//

import SwiftUI

struct BadgeView: View {
    let icon: String
    let text: String
    let value: String
    var body: some View {
        VStack {
            Image(systemName: icon)
                .imageScale(.large)
            Text(text)
                .bold()
            Text(value)
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .foregroundStyle(.secondary)
    }
}

struct BadgeView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView(icon: "wifi.router.fill", text: "Connecting to", value: "127.0.0.1")
    }
}
