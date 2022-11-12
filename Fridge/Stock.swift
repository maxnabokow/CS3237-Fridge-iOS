//
//  Stock.swift
//  Fridge
//
//  Created by Max Nabokow on 11/6/22.
//

import Foundation

struct Stock: Codable {
    let apple: Int
    let banana: Int
    let orange: Int
    let timestamp: String
    let imageString: String
    
    enum CodingKeys: String, CodingKey {
        case apple, banana, orange, timestamp
        case imageString = "img_base64"
    }
}

// Convert timestamp string to Date
extension Stock {
    func timestampAsDate() -> Date {
        let copy = timestamp
        let year = Int(copy.dropFirst(4))
        let month = Int(copy.dropFirst(2))
        let day = Int(copy.dropFirst(2))
        let components = DateComponents(year: year, month: month, day: day)
        return components.date!
    }
}
