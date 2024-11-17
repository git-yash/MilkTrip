//
//  UserGroceriesChartView.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import SwiftUI
import Charts

struct ChartView: View {
    @State var topText: String
    @State var selectedRange: String = "1M"
    @State var allData: [PriceIncrement]
    @State var data: [PriceIncrement] = []
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
                            ForEach(data.indices, id: \.self) { index in
                                let priceIncrement = data[index]
                                LineMark(
                                    x: .value("Date", priceIncrement.timestamp),
                                    y: .value("Price", priceIncrement.price)
                                )
                                .lineStyle(StrokeStyle(lineWidth: 2))
                                .foregroundStyle(Color(hex: "#387f7b"))
                            }
                        }
                        .chartYScale(domain: lowerBound...upperBound)
                        .padding()
                        .cornerRadius(15) // Round the edges of the chart
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
                    let priceIncrement = data[selected.index]
                    let xOffset = CGFloat(selected.index) * (screenWidth - 40) / CGFloat(data.count - 1)
                    VStack {
                        Text("$\(String(format: "%.2f", priceIncrement.price))")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(8)
                            .offset(x: xOffset - screenWidth / 2 + 20, y: -30)

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
            .padding()
        }
        .onAppear {
            updateData(for: selectedRange)
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "#393E46"))
        )
        .padding() // Add padding to the entire view
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
            data = [] // If an unrecognized range is passed, clear data.
            return
        }

        let now = Date()

        // Filter data based on the calculated range
        data = allData.filter { price_increment in
            let date = price_increment.timestamp
            // Compare if the date is within the specified range
            return date > calendar.date(byAdding: .day, value: -days, to: now)!
        }

        if let minPrice = data.min(by: { $0.price < $1.price }) {
            lowerBound = Int(minPrice.price) - 2
        }

        if let maxPrice = data.max(by: { $0.price < $1.price }) {
            upperBound = Int(maxPrice.price) + 2
        }

        data.reverse() // To show the data in chronological order
    }

    private func handleDragGesture(value: DragGesture.Value) {
        let location = value.location
        let chartWidth = screenWidth - 40 // Adjust for padding
        let spacing = chartWidth / CGFloat(data.count - 1)

        let index = Int((location.x - 20) / spacing) // Adjust for padding
        if index >= 0 && index < data.count {
            selectedDataPoint = (index: index, value: data[index].price)
        } else {
            selectedDataPoint = nil
        }
    }
}

#Preview {
    ChartView(topText: "Monthly Spending: $123.24", allData: [])
}
