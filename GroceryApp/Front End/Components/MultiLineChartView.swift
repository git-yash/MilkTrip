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
                        .chartYScale(domain: lowerBound...upperBound)
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
                    let xOffset = CGFloat(selected.index) * (screenWidth - 40) / CGFloat(getDisplayPointsCount() - 1) - (screenWidth - 40) / 2
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 1, height: screenWidth * 0.50)
                        .offset(x: xOffset + 20, y: 0)
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
        
        var tmp_lower_bound = 1000000
        var tmp_upper_bound = 0

        for key in allData.keys {
            // Filter data based on the calculated range
            let filtered = allData[key]?.filter { price_increment in
                let date = price_increment.timestamp
                return date > calendar.date(byAdding: .day, value: -days, to: now)!
            }

            if let minPrice = filtered?.min(by: { $0.price < $1.price }) {
                tmp_lower_bound = min(tmp_lower_bound, Int(minPrice.price) - 2)
            }

            if let maxPrice = filtered?.max(by: { $0.price < $1.price }) {
                tmp_upper_bound = max(tmp_upper_bound, Int(maxPrice.price) + 2)
            }

            displayedData[key] = filtered?.reversed()
        }
        
        lowerBound = tmp_lower_bound
        upperBound = tmp_upper_bound
    }

    private func handleDragGesture(value: DragGesture.Value) {
        let location = value.location
        let chartWidth = screenWidth - 40 // Adjust for padding
        let spacing = chartWidth / CGFloat(getDisplayPointsCount() - 1)

        // Calculate index based on the x-coordinate of the drag location
        let index = Int((location.x - 20) / spacing) // Adjust for padding

        // Ensure index is within the valid range
        if index >= 0, let anyKey = displayedData.keys.first,
           index < (displayedData[anyKey]?.count ?? 0) {
            if let increments = displayedData[anyKey] {
                let dataPoint = increments[index]
                selectedDataPoint = (index: index, value: dataPoint.price)
            }
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
