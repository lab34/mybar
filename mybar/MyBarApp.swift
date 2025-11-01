//
//  MyBarApp.swift
//  MyBar
//
//  Created by Labouc on 01/11/2025.
//

import SwiftUI

@main
struct MyBarApp: App {
    var body: some Scene {
        MenuBarExtra("MyBar", systemImage: "internaldrive") {
            MenuBarView()
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
        }
        .menuBarExtraStyle(.window)
    }
}