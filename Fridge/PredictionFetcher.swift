//
//  PredictionFetcher.swift
//  Fridge
//
//  Created by Max Nabokow on 11/6/22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

class PredictionFetcher {
    static let shared = PredictionFetcher()
    private init() {}

    func fetchPrediction(for itemKey: String) async -> Prediction {
        let collection = Firestore.firestore().collection("predict")
        let query = collection.document(itemKey)
        do {
            let snapshot = try await query.getDocument()
            let data = snapshot.data()
            let historical = data?["historical_data"] as? [Int] ?? []
            let predicted = data?["predicted_data"] as? [Int] ?? []
            let graphString = data?["graph_img_base64"] as? String ?? "NO IMAGE"
            return Prediction(historicalData: historical, predictedData: predicted, graphString: graphString)
        } catch {
            fatalError("Error fetching from Firestore")
        }
    }
}
