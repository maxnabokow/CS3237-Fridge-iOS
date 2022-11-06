//
//  FridgeApp.swift
//  Fridge
//
//  Created by Max Nabokow on 10/18/22.
//

import Firebase
import SwiftUI

@main
struct FridgeApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
