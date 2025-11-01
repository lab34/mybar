//
//  DiskSpaceMonitor.swift
//  MyBar
//
//  Created by Labouc on 01/11/2025.
//

import Foundation

struct DiskSpaceInfo: Codable, Equatable {
    let availableSpace: Double    // en GiB (base 1024)
    let totalSpace: Double        // en GiB (base 1024)
    let timestamp: Date

    init(availableBytes: UInt64, totalBytes: UInt64) {
        // Utiliser la base 1024 (GiB) comme df -h pour cohérence
        self.availableSpace = Double(availableBytes) / (1024.0 * 1024.0 * 1024.0)
        self.totalSpace = Double(totalBytes) / (1024.0 * 1024.0 * 1024.0)
        self.timestamp = Date()
    }
}

class DiskSpaceMonitor: ObservableObject {
    @Published var currentSpace: DiskSpaceInfo?
    @Published var isMonitoring = false
    @Published var errorMessage: String?
    @Published var debugInfo: String = ""

    private let fileManager = FileManager.default
    private var monitoringTimer: Timer?

    // Volume principal à surveiller - CORRIGÉ
    private let primaryVolumePath: String
    private let alternativePaths: [String]

    init() {
        // CORRIGÉ: Sur macOS avec APFS, les données utilisateur sont sur /System/Volumes/Data
        // La racine "/" est souvent un snapshot en lecture seule
        primaryVolumePath = "/System/Volumes/Data"

        // Chemins alternatifs à tester en cas d'échec
        alternativePaths = ["/", "/Volumes/Macintosh HD"]

        print("🔍 MyBar: Initialising with primary volume path: \(primaryVolumePath)")
        debugInfo = "Testing path: \(primaryVolumePath)"

        // Test initial pour valider le chemin
        testVolumePath()
    }

    private func testVolumePath() {
        let url = URL(fileURLWithPath: primaryVolumePath)

        do {
            let resourceValues = try url.resourceValues(forKeys: [
                .volumeAvailableCapacityForImportantUsageKey,
                .volumeTotalCapacityKey
            ])

            if resourceValues.volumeAvailableCapacityForImportantUsage != nil &&
               resourceValues.volumeTotalCapacity != nil {
                print("✅ MyBar: Volume path \(primaryVolumePath) is accessible")
                debugInfo = "✅ Path accessible: \(primaryVolumePath)"
            } else {
                print("⚠️ MyBar: Volume path \(primaryVolumePath) exists but no capacity info")
                debugInfo = "⚠️ No capacity info for \(primaryVolumePath)"
            }
        } catch {
            print("❌ MyBar: Error accessing \(primaryVolumePath): \(error.localizedDescription)")
            debugInfo = "❌ Error: \(error.localizedDescription)"

            // Essayer les chemins alternatifs
            testAlternativePaths()
        }
    }

    private func testAlternativePaths() {
        for path in alternativePaths {
            let url = URL(fileURLWithPath: path)

            do {
                let resourceValues = try url.resourceValues(forKeys: [
                    .volumeAvailableCapacityForImportantUsageKey,
                    .volumeTotalCapacityKey
                ])

                if resourceValues.volumeAvailableCapacityForImportantUsage != nil &&
                   resourceValues.volumeTotalCapacity != nil {
                    print("✅ MyBar: Alternative path \(path) works!")
                    debugInfo = "✅ Alternative path works: \(path)"
                    // Note: Dans une implémentation complète, on pourrait
                    // stocker ce chemin fonctionnel pour l'utiliser
                    break
                }
            } catch {
                print("❌ MyBar: Alternative path \(path) failed: \(error.localizedDescription)")
            }
        }
    }

    func startMonitoring() {
        guard !isMonitoring else {
            print("⚠️ MyBar: Already monitoring")
            return
        }

        print("🚀 MyBar: Starting disk space monitoring")
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
        print("⏹ MyBar: Stopping monitoring")
        isMonitoring = false
        monitoringTimer?.invalidate()
        monitoringTimer = nil
    }

    private func updateDiskSpace() {
        print("🔄 MyBar: Updating disk space info...")

        // Essayer d'abord le chemin principal
        if tryUpdateDiskSpace(for: primaryVolumePath) {
            return
        }

        // Si échec, essayer les chemins alternatifs
        for path in alternativePaths {
            if tryUpdateDiskSpace(for: path) {
                print("✅ MyBar: Successfully used alternative path: \(path)")
                return
            }
        }

        // Si tous les chemins échouent
        let error = DiskSpaceError.unableToReadDiskInfo
        DispatchQueue.main.async {
            self.errorMessage = "Impossible de lire l'espace disque: \(error.localizedDescription)"
            self.debugInfo = "❌ All paths failed"
            print("❌ MyBar: All volume paths failed")
        }
    }

    private func tryUpdateDiskSpace(for path: String) -> Bool {
        do {
            let url = URL(fileURLWithPath: path)
            let resourceValues = try url.resourceValues(forKeys: [
                .volumeAvailableCapacityForImportantUsageKey,
                .volumeTotalCapacityKey
            ])

            guard let availableBytes = resourceValues.volumeAvailableCapacityForImportantUsage,
                  let totalBytes = resourceValues.volumeTotalCapacity else {
                print("⚠️ MyBar: No capacity values for path: \(path)")
                return false
            }

            let diskInfo = DiskSpaceInfo(
                availableBytes: UInt64(availableBytes),
                totalBytes: UInt64(totalBytes)
            )

            DispatchQueue.main.async {
                self.currentSpace = diskInfo
                self.errorMessage = nil
                self.debugInfo = "✅ Updated using: \(path)"
                print("✅ MyBar: Successfully updated - Available: \(diskInfo.availableSpace)GB, Total: \(diskInfo.totalSpace)GB")

                // Notifier les observers que les données ont été mises à jour
                NotificationCenter.default.post(name: NSNotification.Name("DiskSpaceUpdated"), object: diskInfo)
            }

            return true

        } catch {
            print("❌ MyBar: Error updating disk space for \(path): \(error.localizedDescription)")
            return false
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