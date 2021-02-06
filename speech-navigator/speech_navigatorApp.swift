//
//  speech_navigatorApp.swift
//  speech-navigator
//
//  Created by YINSHENG DONG on 2021-02-06.
//

import SwiftUI

@main
struct speech_navigatorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
