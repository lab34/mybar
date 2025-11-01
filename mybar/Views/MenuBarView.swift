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
        VStack(spacing: 2) {
            if let currentSpace = diskMonitor.currentSpace {
                // Affichage normal quand les données sont disponibles
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

            } else if let errorMessage = diskMonitor.errorMessage {
                // Affichage amélioré en cas d'erreur
                VStack(spacing: 1) {
                    Text("-- GB")
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundColor(.orange)

                    Text("⚠️")
                        .font(.system(size: 8))
                        .foregroundColor(.orange)
                }

            } else {
                // État loading amélioré avec plus d'informations
                VStack(spacing: 1) {
                    HStack(spacing: 2) {
                        Text("Loading")
                            .font(.system(size: 11, weight: .medium, design: .monospaced))
                            .foregroundColor(.gray)

                        // Indicateur d'activité simple
                        Text(loadingIndicator)
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                    }

                    // Info de debug en mode développement
                    #if DEBUG
                    if !diskMonitor.debugInfo.isEmpty {
                        Text(diskMonitor.debugInfo)
                            .font(.system(size: 8))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    #endif
                }
                .onAppear {
                    diskMonitor.startMonitoring()
                }
            }
        }
        .frame(minWidth: 60, maxWidth: 120)
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