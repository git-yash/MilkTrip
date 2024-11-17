//
//  MultiChartView.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import SwiftUI
import Charts

struct MultiLineChartView: View {
    @State var topText: String
    @State var selectedRange: String = "1M"
    @State var allData: [String:[PriceIncrement]]
    @State var displayedData: [String:[PriceIncrement]] = [:]
    @State var selectedDataPoint: (index: Int, value: Double)? = nil
    @State var lowerBound: Int = 0
    @State var upperBound: Int = 10

    var screenWidth = UIScreen.main.bounds.width
    let ranges = ["1M", "6M", "YTD", "1Y", "All"]

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "#494C52"))
                    .overlay(
                        Chart {
                            ForEach(displayedData.keys.sorted(), id: \.self) { line in // Sort for consistency
                                if let increments = displayedData[line] { // Safely unwrap the value for the key
                                    ForEach(increments.indices, id: \.self) { index in
                                        let priceIncrement = increments[index]
                                        LineMark(
                                            x: .value("Date", priceIncrement.timestamp),
                                            y: .value("Price", priceIncrement.price)
                                        )
                                        .lineStyle(StrokeStyle(lineWidth: 2))
                                        .foregroundStyle(Color(hex: "#387f7b"))
                                    }
                                }
                            }
                        }
                        .chartYScale(domain: 1...500)
                        .padding()
                        .cornerRadius(15)
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                handleDragGesture(value: value)
                            }
                            .onEnded { _ in
                                selectedDataPoint = nil
                            }
                    )
                    .frame(height: screenWidth * 0.55)

                if let selected = selectedDataPoint {
                    let xOffset = CGFloat(selected.index) * (screenWidth - 40) / CGFloat(displayedData.count - 1)
                    VStack {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 1, height: screenWidth * 0.50)
                            .offset(x: xOffset - screenWidth / 2 + 20, y: -screenWidth * 0.1)
                    }
                }
            }

            HStack {
                ForEach(ranges, id: \.self) { range in
                    Button(action: {
                        selectedRange = range
                        updateData(for: range)
                    }) {
                        Text(range)
                            .fontWeight(selectedRange == range ? .bold : .regular)
                            .padding(10)
                            .background(selectedRange == range ? .accentColor.opacity(0.2) : Color.clear)
                            .cornerRadius(5)
                    }
                }
                Spacer()
            }
        }
        .onAppear {
            updateData(for: selectedRange)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "#393E46"))
        )
    }

    private func updateData(for range: String) {
        let calendar = Calendar.current
        let formatter = DateFormatter()

        var days = 0

        switch range {
        case "1M":
            formatter.dateFormat = "MMM dd" // Short month names with day, e.g., Oct 18
            days = 30
        case "6M":
            formatter.dateFormat = "MMM" // Short month names, e.g., Jan
            days = 182
        case "YTD":
            let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: Date()))!
            days = calendar.dateComponents([.day], from: startOfYear, to: Date()).day!
        case "1Y":
            formatter.dateFormat = "MMM" // Short month names, Jan, Feb
            days = 365
        case "All":
            formatter.dateFormat = "yyyy" // Year format
            days = 100000
        default:
            displayedData = [:] // If an unrecognized range is passed, clear data.
            return
        }

        let now = Date()

        for key in allData.keys {
            // Filter data based on the calculated range
            let filtered = allData[key]?.filter { price_increment in
                let date = price_increment.timestamp
                // Compare if the date is within the specified range
                return date > calendar.date(byAdding: .day, value: -days, to: now)!
            }

            displayedData[key] = filtered?.reversed()
        }
    }

    private func handleDragGesture(value: DragGesture.Value) {
        let location = value.location
        let chartWidth = screenWidth - 40 // Adjust for padding
        let spacing = chartWidth / CGFloat(getDisplayPointsCount() - 1)

        let index = Int((location.x - 20) / spacing) // Adjust for padding
        if index >= 0 && index < displayedData.count {
            selectedDataPoint = (index: index, value: 0)
        } else {
            selectedDataPoint = nil
        }
    }
    
    func getDisplayPointsCount() -> Int {
        let anyKey = displayedData.keys.sorted()[0]
        
        return displayedData[anyKey]?.count ?? 10
    }
}

#Preview {
    MultiLineChartView(topText: "Monthly Spending: $123.24", allData: [:])
}
