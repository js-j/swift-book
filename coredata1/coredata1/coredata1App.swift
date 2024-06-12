//
//  coredata1App.swift
//  coredata1
//
//  Created by reggie regs on 10.06.24.
//

import SwiftUI

@main
struct coredata1App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
