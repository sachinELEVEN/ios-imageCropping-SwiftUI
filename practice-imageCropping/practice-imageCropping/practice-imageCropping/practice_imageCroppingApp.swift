//
//  practice_imageCroppingApp.swift
//  practice-imageCropping
//
//  Created by sachin jeph on 12/06/22.
//

import SwiftUI

@main
struct practice_imageCroppingApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
