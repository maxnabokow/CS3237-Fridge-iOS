//
//  StockFetcher.swift
//  Fridge
//
//  Created by Max Nabokow on 11/6/22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class StockFetcher {
    static let shared = StockFetcher()
    private init() {}
    
    func fetchStock() async -> Stock {
        let collection = Firestore.firestore().collection("stocks")
        let query = collection
            .order(by: "timestamp", descending: true)
            .limit(to: 1)
        
        do {
            let snapshot = try await query.getDocuments()
            do {
                let mostRecent = snapshot.documents[0]
                let output = try mostRecent.data(as: Stock.self)
                return output
            } catch {
                fatalError("Error decoding from Firestore")
            }
        } catch {
            fatalError("Error fetching from Firestore")
        }
    }
}
