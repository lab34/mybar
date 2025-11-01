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
        VStack(spacing: 1) {
            if let currentSpace = diskMonitor.currentSpace {
                // Affichage compact sur une seule ligne
                HStack(spacing: 4) {
                    Text(diskMonitor.formatGB(currentSpace.availableSpace))
                        .font(.system(size: 12, weight: .medium, design: .monospaced))

                    if storageManager.dailyDelta != 0.0 {
                        Text(storageManager.formatDelta(storageManager.dailyDelta))
                            .font(.system(size: 11, weight: .regular, design: .monospaced))
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
                HStack(spacing: 2) {
                    Text("-- GB")
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundColor(.orange)
                    Text("⚠️")
                        .font(.system(size: 10))
                        .foregroundColor(.orange)
                }

            } else {
                // État loading compact
                HStack(spacing: 2) {
                    Text("Loading")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundColor(.gray)
                    Text(loadingIndicator)
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
                .onAppear {
                    diskMonitor.startMonitoring()
                }
            }
        }
        .frame(minWidth: 80, maxWidth: 150)
    }

    // Indicateur de loading animé
    private var loadingIndicator: String {
        let indicators = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]
        let index = Int(Date().timeIntervalSince1970) % indicators.count
        return indicators[index]
    }
}

#Preview {
    MenuBarView()
}