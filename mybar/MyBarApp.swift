//
//  MyBarApp.swift
//  MyBar
//
//  Created by Labouc on 01/11/2025.
//

import SwiftUI
import AppKit

@main
struct MyBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var diskMonitor = DiskSpaceMonitor()
    var storageManager = StorageManager()
    var updateTimer: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusBar()
        diskMonitor.startMonitoring()
        scheduleUpdates()
    }

    private func setupStatusBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.title = "Loading..."
            button.font = NSFont.systemFont(ofSize: 11) // Police plus petite

            // Ajouter un menu simple
            let menu = NSMenu()
            menu.addItem(NSMenuItem(title: "Quitter", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
            statusItem?.menu = menu
        }

        updateDisplay()
    }

    private func updateDisplay() {
        guard let button = statusItem?.button else { return }

        if let currentSpace = diskMonitor.currentSpace {
            let spaceText = diskMonitor.formatGB(currentSpace.availableSpace)

            if storageManager.dailyDelta != 0.0 {
                let deltaText = storageManager.formatDelta(storageManager.dailyDelta)
                button.title = "\(spaceText) \(deltaText)"
            } else {
                button.title = spaceText
            }

            storageManager.saveMeasurement(currentSpace)
        } else if diskMonitor.errorMessage != nil {
            button.title = "-- GB ⚠️"
            button.attributedTitle = NSAttributedString(
                string: button.title,
                attributes: [.foregroundColor: NSColor.orange]
            )
        } else {
            button.title = "Loading..."
            button.attributedTitle = NSAttributedString(
                string: button.title,
                attributes: [.foregroundColor: NSColor.gray]
            )
        }
    }

    private func scheduleUpdates() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.updateDisplay()
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        updateTimer?.invalidate()
        if let statusItem = statusItem {
            NSStatusBar.system.removeStatusItem(statusItem)
        }
    }
}