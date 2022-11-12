//
//  SettingsView.swift
//  Fridge
//
//  Created by Max Nabokow on 11/6/22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct SettingsView: View {
    @State private var config: Config
    @State private var prevConfig: Config
    
    init(config: Config) {
        self.config = config
        self.prevConfig = config
    }
    
    var body: some View {
        VStack {
            List {
                Section {
                    Stepper("Historical Window: \(config.historicalWindow)", value: $config.historicalWindow)
                    Stepper("Prediction Window: \(config.predictionWindow)", value: $config.predictionWindow)
                }
                Button {
                    SettingsSaver.shared.save(config: config)
                    prevConfig = config
                } label: {
                    Text("Save")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(prevConfig != config ? Color.blue : Color.gray.opacity(0.2))
                        .disabled(prevConfig == config)
                        .cornerRadius(8)
                }
            }
            
        }
        .task {
            do {
                config = try await Firestore.firestore().collection("config").document("config").getDocument(as: Config.self)
                prevConfig = config
            } catch {
                fatalError("Couldn't get config from Firestore")
            }
        }
    }
}

struct Config: Codable, Equatable {
    var historicalWindow: Int
    var predictionWindow: Int
    
    enum CodingKeys: String, CodingKey {
        case historicalWindow = "historical_window"
        case predictionWindow = "prediction_window"
    }
}

class SettingsSaver {
    static let shared = SettingsSaver()
    private init() {}
    
    func save(config: Config) {
        let ref = Firestore.firestore().collection("config").document("config")
        do {
            try ref.setData(from: config)
        } catch {
            fatalError("Failed to set config")
        }
    }
}
