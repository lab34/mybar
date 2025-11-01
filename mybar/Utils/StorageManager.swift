//
//  StorageManager.swift
//  MyBar
//
//  Created by Labouc on 01/11/2025.
//

import Foundation

class StorageManager: ObservableObject {
    @Published var dailyDelta: Double = 0.0

    private let userDefaults = UserDefaults.standard
    private let lastMeasurementKey = "lastDiskSpaceMeasurement"
    private let dayStartMeasurementKey = "dayStartMeasurement"

    init() {
        calculateDailyDelta()
    }

    func saveMeasurement(_ info: DiskSpaceInfo) {
        saveLastMeasurement(info)
        checkAndUpdateDayStartMeasurement(info)
        calculateDailyDelta()
    }

    private func saveLastMeasurement(_ info: DiskSpaceInfo) {
        if let data = try? JSONEncoder().encode(info) {
            userDefaults.set(data, forKey: lastMeasurementKey)
        }
    }

    private func checkAndUpdateDayStartMeasurement(_ info: DiskSpaceInfo) {
        let calendar = Calendar.current
        let now = Date()
        let today = calendar.startOfDay(for: now)

        // Récupérer la mesure de début de journée actuelle
        if let dayStartData = userDefaults.data(forKey: dayStartMeasurementKey),
           let dayStartInfo = try? JSONDecoder().decode(DiskSpaceInfo.self, from: dayStartData) {

            let dayStartDate = calendar.startOfDay(for: dayStartInfo.timestamp)

            // Si c'est un nouveau jour, utiliser la mesure actuelle comme début de journée
            if dayStartDate < today {
                saveDayStartMeasurement(info)
            }
        } else {
            // Pas de mesure de début de journée, en créer une
            saveDayStartMeasurement(info)
        }
    }

    private func saveDayStartMeasurement(_ info: DiskSpaceInfo) {
        if let data = try? JSONEncoder().encode(info) {
            userDefaults.set(data, forKey: dayStartMeasurementKey)
        }
    }

    private func calculateDailyDelta() {
        guard let dayStartData = userDefaults.data(forKey: dayStartMeasurementKey),
              let dayStartInfo = try? JSONDecoder().decode(DiskSpaceInfo.self, from: dayStartData) else {
            dailyDelta = 0.0
            return
        }

        // Vérifier si on est toujours le même jour
        let calendar = Calendar.current
        let now = Date()
        let dayStartDate = calendar.startOfDay(for: dayStartInfo.timestamp)
        let today = calendar.startOfDay(for: now)

        if dayStartDate == today {
            // Même jour : calculer le delta avec la dernière mesure
            if let lastData = userDefaults.data(forKey: lastMeasurementKey),
               let lastInfo = try? JSONDecoder().decode(DiskSpaceInfo.self, from: lastData) {
                dailyDelta = lastInfo.availableSpace - dayStartInfo.availableSpace
            }
        } else {
            // Nouveau jour : le delta est de 0 pour l'instant
            dailyDelta = 0.0
        }
    }

    func formatDelta(_ delta: Double) -> String {
        let absDelta = abs(delta)
        let sign = delta >= 0 ? "+" : "-"
        return "\(sign)\(String(format: "%.1f", absDelta)) GB"
    }

    func resetDayStart() {
        userDefaults.removeObject(forKey: dayStartMeasurementKey)
        dailyDelta = 0.0
    }
}