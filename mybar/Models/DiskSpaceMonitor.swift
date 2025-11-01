//
//  DiskSpaceMonitor.swift
//  MyBar
//
//  Created by Labouc on 01/11/2025.
//

import Foundation

struct DiskSpaceInfo: Codable {
    let availableSpace: Double    // en GB
    let totalSpace: Double        // en GB
    let timestamp: Date

    init(availableBytes: UInt64, totalBytes: UInt64) {
        self.availableSpace = Double(availableBytes) / (1024 * 1024 * 1024)
        self.totalSpace = Double(totalBytes) / (1024 * 1024 * 1024)
        self.timestamp = Date()
    }
}

class DiskSpaceMonitor: ObservableObject {
    @Published var currentSpace: DiskSpaceInfo?
    @Published var isMonitoring = false
    @Published var errorMessage: String?

    private let fileManager = FileManager.default
    private var monitoringTimer: Timer?

    // Volume principal à surveiller
    private let primaryVolumePath = "/"

    init() {
        // Vérifier si on est sur macOS avec APFS et prendre le bon chemin
        #if targetEnvironment(macCatalyst) || os(macOS)
        if let volumes = fileManager.urls(forDirectory: .documentDirectory, inDomains: .localDomainMask).first,
           let volume = volumes.pathComponents.first,
           volume != "/" {
            primaryVolumePath = "/\(volume)"
        }
        #endif
    }

    func startMonitoring() {
        guard !isMonitoring else { return }

        isMonitoring = true
        updateDiskSpace()

        // Timer économique : toutes les 5 minutes
        monitoringTimer = Timer.scheduledTimer(withTimeInterval: 300.0, repeats: true) { [weak self] _ in
            self?.updateDiskSpace()
        }

        // Configuration du timer pour économie d'énergie
        monitoringTimer?.tolerance = 30.0 // Tolérance de 30 secondes
    }

    func stopMonitoring() {
        isMonitoring = false
        monitoringTimer?.invalidate()
        monitoringTimer = nil
    }

    private func updateDiskSpace() {
        do {
            let resourceValues = try fileManager.resourceValues(forKeys: [
                .volumeAvailableCapacityForImportantUsageKey,
                .volumeTotalCapacityKey
            ], at: URL(fileURLWithPath: primaryVolumePath))

            guard let availableBytes = resourceValues.volumeAvailableCapacityForImportantUsage,
                  let totalBytes = resourceValues.volumeTotalCapacity else {
                throw DiskSpaceError.unableToReadDiskInfo
            }

            DispatchQueue.main.async {
                self.currentSpace = DiskSpaceInfo(
                    availableBytes: availableBytes,
                    totalBytes: totalBytes
                )
                self.errorMessage = nil
            }

        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Erreur lecture espace disque: \(error.localizedDescription)"
            }
        }
    }

    func formatGB(_ value: Double) -> String {
        return String(format: "%.1f GB", value)
    }

    deinit {
        stopMonitoring()
    }
}

enum DiskSpaceError: LocalizedError {
    case unableToReadDiskInfo
    case volumeNotFound

    var errorDescription: String? {
        switch self {
        case .unableToReadDiskInfo:
            return "Impossible de lire les informations du disque"
        case .volumeNotFound:
            return "Volume non trouvé"
        }
    }
}