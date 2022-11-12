//
//  Prediction.swift
//  Fridge
//
//  Created by Max Nabokow on 11/6/22.
//

import Foundation

struct Prediction: Codable {
    let historicalData: [Int]
    let predictedData: [Int]
    let graphString: String
    
    enum CodingKeys: String, CodingKey {
        case historicalData = "historical_data"
        case predictedData = "predicted_data"
        case graphString = "graph_img_base64"
    }
}
