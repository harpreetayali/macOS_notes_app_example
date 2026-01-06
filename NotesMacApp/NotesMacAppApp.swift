//
//  NotesMacAppApp.swift
//  NotesMacApp
//
//  Created by Harpreet Singh on 05/01/26.
//

import SwiftUI
import SwiftData

@main
struct NotesMacAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 320, minHeight: 400)
        }
        .windowResizability(.contentSize)
        .modelContainer(for: [Note.self, NoteCategory.self])
    }
}
