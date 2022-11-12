//
//  StocksView.swift
//  Fridge
//
//  Created by Max Nabokow on 11/6/22.
//

import Charts
import Foundation
import SwiftUI

struct StocksView: View {
    @Binding var stock: Stock?
    @Binding var predictions: [String: Prediction]

    @State private var refreshing = false

    var body: some View {
        NavigationStack {
            ZStack {
                Group {
                    if let stock = stock {
                        VStack {
                            if !stock.imageString.isEmpty {
                                Image(base64String: stock.imageString)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding()
                            }
                            NavigationLink(destination: detailView(for: "apple", count: stock.apple)) {
                                HStack {
                                    Text("🍎 Apples")
                                    Spacer()
                                    Text("\(stock.apple)")
                                    Image(systemName: "chevron.right")
                                }
                                .foregroundColor(.red)
                                .padding()
                                .background(Color.red.gradient.opacity(0.15))
                            }

                            NavigationLink(destination: detailView(for: "banana", count: stock.banana)) {
                                HStack {
                                    Text("🍌 Bananas")
                                    Spacer()
                                    Text("\(stock.banana)")
                                    Image(systemName: "chevron.right")
                                }
                                .foregroundColor(.yellow)
                                .padding()
                                .background(Color.yellow.gradient.opacity(0.15))
                            }

                            NavigationLink(destination: detailView(for: "orange", count: stock.orange)) {
                                HStack {
                                    Text("🍊 Oranges")
                                    Spacer()
                                    Text("\(stock.orange)")
                                    Image(systemName: "chevron.right")
                                }
                                .foregroundColor(.orange)
                                .padding()
                                .background(Color.orange.gradient.opacity(0.15))
                            }
                        }
                        .font(.largeTitle)
                        .padding()
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "square.stack.fill")
                                .imageScale(.large)
                                .font(.largeTitle)
                                .foregroundColor(.secondary)
                            Text("No Stock")
                                .font(.title3)
                        }
                    }
                }
                if refreshing {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        Task {
                            await refresh()
                        }
                    } label: {
                        Label("Refresh", systemImage: "arrow.clockwise")
                            .labelStyle(.titleAndIcon)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView(config: .init(historicalWindow: 0, predictionWindow: 0))) {
                        Image(systemName: "gearshape.fill")
                            .contentShape(Rectangle())
                    }
                }
            }
        }
        .task {
            await refresh()
        }
    }

    private func refresh() async {
        refreshing = true
        stock = await StockFetcher.shared.fetchStock()
        predictions = [:]
        for item in ["apple", "banana", "orange"] {
            let prediction = await PredictionFetcher.shared.fetchPrediction(for: item)
            predictions[item] = prediction
        }
        refreshing = false
    }

    private func detailView(for item: String, count: Int) -> some View {
        guard let prediction = predictions[item] else { return AnyView(Text("No Prediction")) }
        return AnyView(StockDetailView(item: item, count: count, prediction: prediction))
    }
}

struct StockDetailView: View {
    let item: String
    let count: Int
    let prediction: Prediction

    var chartData: [[(Int, Int)]] {
        var output: [[(Int, Int)]] = [[], []]
        for (i, value) in prediction.historicalData.enumerated() {
            output[0].append((-prediction.historicalData.count + i + 1, value))
        }

        for (i, value) in prediction.predictedData.enumerated() {
            output[1].append((i + 1, value))
        }

        print(output)

        return output
    }

    var maxValue: Int {
        let historyMax = prediction.historicalData.max()!
        let predictedMax = prediction.predictedData.max()!
        let raw = Swift.max(historyMax, predictedMax)
        let padded = raw + max(1, raw / 4)
        return padded
    }

    enum GraphStyle: String, CaseIterable {
        case custom = "Custom"
        case sarima = "SARIMA"
    }

    @State private var graphStyle: GraphStyle = .custom

    var body: some View {
        VStack {
            Picker("Graph Style", selection: $graphStyle) {
                ForEach(GraphStyle.allCases, id: \.self) { option in
                    Text(option.rawValue)
                }
            }
            .pickerStyle(.segmented)
            Group {
                if graphStyle == .custom {
                    VStack {
                        Text("Historical Consumption")
                        Chart {
                            ForEach(chartData[0], id: \.0) { index, value in
                                LineMark(
                                    x: .value("Day", index),
                                    y: .value("Historical Consumption", value)
                                )
                                .interpolationMethod(.cardinal)
                                .foregroundStyle(.blue)
                            }
                        }
                        .chartYScale(domain: 0...maxValue)
                        .chartXAxis {
                            AxisMarks(values: .stride(by: 7), stroke: StrokeStyle(lineWidth: 1))
                        }

                        VStack {
                            Text("Predicted Consumption")
                                .font(.headline)
                            Text("Next \(prediction.predictedData.count) days")
                            Chart {
                                ForEach(chartData[1], id: \.0) { index, value in
                                    LineMark(
                                        x: .value("Day", index),
                                        y: .value("Predicted Consumption", value)
                                    )
                                    .interpolationMethod(.cardinal)
                                    .foregroundStyle(.orange)
                                }
                            }
                            .chartYScale(domain: 0...maxValue)
                            .chartXScale(domain: 0...prediction.historicalData.count + 1)
                            .chartXAxis {
                                AxisMarks(values: .stride(by: 7), stroke: StrokeStyle(lineWidth: 1))
                            }
                        }
                    }
                } else {
                    Image(base64String: prediction.graphString)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
        }
        .padding()
        .navigationTitle(item.capitalized)
    }
}

extension Image {
    init(base64String: String) {
        let imageData = Data(base64Encoded: base64String)!
        let uiImage = UIImage(data: imageData)!
        self.init(uiImage: uiImage)
    }
}

extension Bool: Plottable {
    public init?(primitivePlottable: String) {
        self.init(primitivePlottable == "true")
    }

    public var primitivePlottable: String { self ? "true" : "false" }
//    init?(primitivePlottable: String) { ... }
}
