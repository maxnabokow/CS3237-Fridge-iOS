//
//  AtTheStoreView.swift
//  Fridge
//
//  Created by Max Nabokow on 11/6/22.
//

import Foundation
import SwiftUI

struct AtTheStoreView: View {
    @Binding var stock: Stock?
    @Binding var predictions: [String: Prediction]
    
    private var numPredicted: Int { predictions["apple"]?.predictedData.count ?? 0 }
    
    private var applesNeeded: Int {
        let preds = predictions["apple"]
        let totalInWindow = preds?.predictedData.reduce(0, +) ?? 0
        return totalInWindow - stock!.apple
    }
    
    private var bananasNeeded: Int {
        let preds = predictions["banana"]
        let totalInWindow = preds?.predictedData.reduce(0, +) ?? 0
        return totalInWindow - stock!.banana
    }
    
    private var orangesNeeded: Int {
        let preds = predictions["orange"]
        let totalInWindow = preds?.predictedData.reduce(0, +) ?? 0
        return totalInWindow - stock!.orange
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 50) {
                VStack {
                    Text("For the next \(numPredicted) days")
                    Text("Based on predicted consumption")
                        .font(.caption)
                }
                
                VStack(alignment: .leading) {
                    if applesNeeded != 0 || bananasNeeded != 0 || orangesNeeded != 0 {
                        if applesNeeded > 0 {
                            HStack {
                                Text("🍎 Apples")
                                Spacer()
                                Text("\(applesNeeded)")
                            }
                        }
                        if bananasNeeded > 0 {
                            HStack {
                                Text("🍌 Bananas")
                                Spacer()
                                Text("\(bananasNeeded)")
                            }
                        }
                        if orangesNeeded > 0 {
                            HStack {
                                Text("🍊 Oranges")
                                Spacer()
                                Text("\(orangesNeeded)")
                            }
                        }
                    } else {
                        VStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.gray.opacity(0.5))
                            Text("All stocked up!")
                        }
                        .font(.largeTitle)
                    }
                }
                .font(.largeTitle)
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Need To Buy")
        }
    }
}
