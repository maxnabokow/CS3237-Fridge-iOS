//
//  ContentView.swift
//  Fridge
//
//  Created by Max Nabokow on 10/18/22.
//

import SwiftUI

struct ContentView: View {
    @State private var stock: Stock?
    @State private var predictions: [String: Prediction] = [:]
    
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
        StocksView(stock: $stock, predictions: $predictions)
    }

    private var shopTab: some View {
        AtTheStoreView(stock: $stock, predictions: $predictions)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
