//
//  MenuBarView.swift
//  MyBar
//
//  Created by Labouc on 01/11/2025.
//

import SwiftUI

struct MenuBarView: View {
    @StateObject private var diskMonitor = DiskSpaceMonitor()
    @StateObject private var storageManager = StorageManager()

    var body: some View {
        if let currentSpace = diskMonitor.currentSpace {
            VStack(spacing: 2) {
                Text(diskMonitor.formatGB(currentSpace.availableSpace))
                    .font(.system(size: 12, weight: .medium, design: .monospaced))

                if storageManager.dailyDelta != 0.0 {
                    Text(storageManager.formatDelta(storageManager.dailyDelta))
                        .font(.system(size: 10, weight: .regular, design: .monospaced))
                        .foregroundColor(storageManager.dailyDelta < 0 ? .red : .green)
                }
            }
            .onAppear {
                diskMonitor.startMonitoring()
            }
            .onChange(of: diskMonitor.currentSpace) { newSpace in
                if let space = newSpace {
                    storageManager.saveMeasurement(space)
                }
            }
        } else if diskMonitor.errorMessage != nil {
            Text("-- GB")
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundColor(.orange)
        } else {
            Text("Loading...")
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    MenuBarView()
}