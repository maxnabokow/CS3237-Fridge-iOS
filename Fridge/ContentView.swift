//
//  ContentView.swift
//  Fridge
//
//  Created by Max Nabokow on 10/18/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            stockTab
                .tabItem {
                    Label("Stock", systemImage: "square.stack.fill")
                }
            shopTab
                .tabItem {
                    Label("At the Shop", systemImage: "cart.fill")
                }
        }
    }

    private var stockTab: some View {
        VStack(spacing: 16) {
            Image(systemName: "square.stack.fill")
                .imageScale(.large)
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text("No Stock")
                .font(.title3)
        }
    }

    private var shopTab: some View {
        VStack(spacing: 16) {
            Image(systemName: "cart.fill")
                .imageScale(.large)
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text("You're not at the store, dumbass.")
                .font(.title3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
