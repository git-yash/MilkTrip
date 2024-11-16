//
//  UserGroceriesChartView.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import SwiftUI
import Charts

struct ChartView: View {
    @State private var selectedRange: String = "1W"
    @State private var data: [(String, Double)] = []
    @State private var selectedDataPoint: (index: Int, value: Double)? = nil
    
    var screenWidth = UIScreen.main.bounds.width
    
    let ranges = ["1W", "1M", "6M", "YTD", "1Y", "All"]
    
    var body: some View {
        VStack {
            // Line Chart with Drag Gesture
            ZStack {
                Chart {
                    ForEach(data.indices, id: \.self) { index in
                        let (label, value) = data[index]
                        LineMark(
                            x: .value("Date", label),
                            y: .value("Price", value)
                        )
                        .lineStyle(StrokeStyle(lineWidth: 2))
                        .foregroundStyle(Color(hex: "#387f7b"))
                    }
                }
                .chartYScale(domain: 0...100)
                .frame(height: screenWidth * 0.50)
                .padding()
                .cornerRadius(10)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            handleDragGesture(value: value)
                        }
                        .onEnded { _ in
                            selectedDataPoint = nil
                        }
                )
                
                // Overlay for Selected Price
                if let selected = selectedDataPoint {
                    let xOffset = CGFloat(selected.index) * (screenWidth - 40) / CGFloat(data.count - 1)
                    VStack {
                        // Price Display
                        Text("$\(String(format: "%.2f", selected.value))")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(8)
                            .offset(x: xOffset - screenWidth / 2 + 20, y: -30) // Adjusted vertical offset

                        // Vertical Line (adjusted height)
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 1, height: screenWidth * 0.50) // Adjusted to match chart height
                            .offset(x: xOffset - screenWidth / 2 + 20, y: -screenWidth * 0.1) // Adjusted position
                    }
                }

            }
            
            // Selector
            HStack {
                ForEach(ranges, id: \.self) { range in
                    Button(action: {
                        selectedRange = range
                        updateData(for: range)
                    }) {
                        Text(range)
                            .fontWeight(selectedRange == range ? .bold : .regular)
                            .padding(10)
                            .background(selectedRange == range ? Color.blue.opacity(0.2) : Color.clear)
                            .cornerRadius(5)
                    }
                }
            }
            .padding(.vertical)
        }
        .onAppear {
            updateData(for: selectedRange)
        }
    }
    
    private func updateData(for range: String) {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        
        switch range {
        case "1W":
            formatter.dateFormat = "EEE" // Short day names, e.g., Mon, Tue
            data = (0..<7).map { i in
                let date = calendar.date(byAdding: .day, value: -i, to: Date())!
                return (formatter.string(from: date), Double.random(in: 20...80))
            }
        case "1M":
            formatter.dateFormat = "MMM dd" // Short month names with day, e.g., Oct 18
            data = stride(from: 0, through: 28, by: 7).map { i in
                let date = calendar.date(byAdding: .day, value: -i, to: Date())!
                return (formatter.string(from: date), Double.random(in: 20...80))
            }
        case "6M":
            formatter.dateFormat = "MMM" // Short month names, e.g., Jan
            data = (0..<6).map { i in
                let date = calendar.date(byAdding: .month, value: -i, to: Date())!
                return (formatter.string(from: date), Double.random(in: 20...80))
            }
        case "YTD":
            formatter.dateFormat = "MMM" // Short month names, Jan, Feb
            let monthsElapsed = calendar.component(.month, from: Date())
            data = (0..<monthsElapsed).map { i in
                let date = calendar.date(byAdding: .month, value: -i, to: Date())!
                return (formatter.string(from: date), Double.random(in: 20...80))
            }
        case "1Y":
            formatter.dateFormat = "MMM" // Short month names, Jan, Feb
            data = (0..<12).map { i in
                let date = calendar.date(byAdding: .month, value: -i, to: Date())!
                return (formatter.string(from: date), Double.random(in: 20...80))
            }
        case "All":
            formatter.dateFormat = "yyyy" // Year format
            data = (0..<10).map { i in
                let date = calendar.date(byAdding: .year, value: -i, to: Date())!
                return (formatter.string(from: date), Double.random(in: 20...80))
            }
        default:
            data = []
        }
        data.reverse() // To show the data in chronological order
    }
    
    private func handleDragGesture(value: DragGesture.Value) {
        let location = value.location
        let chartWidth = screenWidth - 40 // Adjust for padding
        let spacing = chartWidth / CGFloat(data.count - 1)
        
        let index = Int((location.x - 20) / spacing) // Adjust for padding
        if index >= 0 && index < data.count {
            selectedDataPoint = (index: index, value: data[index].1)
        } else {
            selectedDataPoint = nil
        }
    }
}
#Preview {
    ChartView()
}
