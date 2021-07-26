//
//  FriendfaceApp.swift
//  Friendface
//
//  Created by Bruce Gilmour on 2021-07-25.
//

import SwiftUI

@main
struct FriendfaceApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
