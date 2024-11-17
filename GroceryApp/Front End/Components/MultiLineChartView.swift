//
//  MultiChartView.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/16/24.
//

import SwiftUI
import Charts

enum MultiLineChartType: String, CaseIterable, Plottable {
    case walmart = "Walmart"
    case heb = "HEB"
    case cvs = "CVS"
    case randalls = "Randalls"
    
    var color: Color {
        switch self {
        case .walmart: return .green
        case .heb: return .blue
        case .cvs: return .orange
        case .randalls: return .red
        }
    }
}

struct MultiLineChartData: Hashable {
    var id = UUID()
    var date: Date
    var value: Double
    
    var type: MultiLineChartType
}

struct MultiLineChartView: View {
    @State var topText: String = "Average Inflation"
    @State var selectedRange: String = "1M"
    @State var allData: [MultiLineChartData]
    @State var displayedData: [MultiLineChartData] = []
    @State var hiddenStores: [MultiLineChartType] = []
    @State var selectedDataPoint: Int? = nil
    @State var lowerBound: Int = 0
    @State var upperBound: Int = 10
    @State var percentageChange: Double = 0.0;

    var screenWidth = UIScreen.main.bounds.width
    let ranges = ["1M", "6M", "YTD", "1Y", "All"]

    var body: some View {
        VStack {
            HStack {
                Text(topText)
                    .padding(.leading, 5)
                    .font(.system(size: 28)).bold()
                Spacer()
                Text(String(format: "%.2f", percentageChange)+"%")
                    .foregroundColor(percentageChange >= 0 ? .red : .green)
                    .font(.system(size: 18))
                    .padding(.trailing, 5)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "#494C52"))
                    .overlay(
                        Chart{
                            ForEach(displayedData, id: \.self) { item in
                                LineMark(
                                    x: .value("Date", item.date),
                                    y: .value("Price", item.value)
                                )
                                .foregroundStyle(item.type.color)
                                .foregroundStyle(by: .value("Plot", item.type))
                            }
                        }
                        .chartYScale(domain: lowerBound...upperBound)
                        .padding()
                        .cornerRadius(15)
                        .chartLegend(.hidden)
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
                    let xOffset = CGFloat(selected) * (screenWidth - 40) / CGFloat(displayedData.count - 1)

                    Rectangle()
                        .fill(Color.white.opacity(0.6))
                        .frame(width: 1, height: screenWidth * 0.40)
                        .offset(x: xOffset - screenWidth / 2 + 20)
                }
            }

            // Range selector buttons
            rangeSelector

            // Divider with white color and opacity
            customDivider

            // Store filters section
            storeFilters
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

    // Custom Divider with white color and opacity
    private var customDivider: some View {
        Divider()
            .background(Color.white)
            .opacity(0.80)
            .padding(.vertical)
    }

    // Range Selector (the HStack with buttons for range selection)
    private var rangeSelector: some View {
        HStack {
            Spacer()
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
                Spacer()
            }
        }
    }

//     Store Filters Section
    private var storeFilters: some View {
        VStack(alignment: .leading) {
            Text("Store Filters")
                .font(.system(size: 18))
                .bold()
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(MultiLineChartType.allCases, id: \.self) { type in
                        Button {
                            if let index = hiddenStores.firstIndex(of: type) {
                                hiddenStores.remove(at: index)
                            } else {
                                if hiddenStores.count != MultiLineChartType.allCases.count - 1{
                                    hiddenStores.append(type)
                                }
                            }
                            updateData(for: selectedRange)
                        } label: {
                            HStack(spacing: 4) {
                                Rectangle()
                                    .fill(type.color)
                                    .frame(width: 12, height: 12)
                                    .cornerRadius(2)
                                Text(type.rawValue)
                                    .font(.system(size: 12))
                            }
                            .padding(7)
                            .background(hiddenStores.contains(type) ? Color(hex: "#494C52") : .gray)
                            .cornerRadius(3)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
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
            displayedData = [] // If an unrecognized range is passed, clear data.
            return
        }

        let now = Date()
        
        var tmp_lower_bound = 1000000
        var tmp_upper_bound = 0

        let filtered = allData.filter { price_increment in
            let date = price_increment.date
            let store = price_increment.type
            return date > calendar.date(byAdding: .day, value: -days, to: now)! && !hiddenStores.contains(store)
        }

        if let minPrice = filtered.min(by: { $0.value < $1.value }) {
            tmp_lower_bound = min(tmp_lower_bound, Int(minPrice.value) - 2)
        }

        if let maxPrice = filtered.max(by: { $0.value < $1.value }) {
            tmp_upper_bound = max(tmp_upper_bound, Int(maxPrice.value) + 2)
        }

        displayedData = filtered

        lowerBound = tmp_lower_bound
        upperBound = tmp_upper_bound
        
        updatePercentageChange()
    }

    private func handleDragGesture(value: DragGesture.Value) {
        let location = value.location
        let chartWidth = screenWidth - 40
        let spacing = chartWidth / CGFloat(displayedData.count - 1)

        let index = Int((location.x - 20) / spacing)
        if index >= 0 && index < displayedData.count {
            selectedDataPoint = index
        } else {
            selectedDataPoint = nil
        }
    }
    
    private func updatePercentageChange() -> Void {
        var allChanges: [Double] = []
        
        for store in MultiLineChartType.allCases {
            if !(hiddenStores.contains(store)){
                allChanges.append(getPercentageChange(store: store))
            }
        }
        
        percentageChange = Double(allChanges.reduce(0, +)) / Double(allChanges.count)
    }
    
    func getPercentageChange(store: MultiLineChartType) -> Double{
        let calendar = Calendar.current
        let formatter = DateFormatter()

        var days = 0

        switch selectedRange {
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
            print("unreachable")
        }

        let now = Date()

        let filtered = allData.filter { price_increment in
            let date = price_increment.date
            let this_store = price_increment.type
            return date > calendar.date(byAdding: .day, value: -days, to: now)! && this_store == store
        }

        let initial = filtered.min(by: { $0.date < $1.date })?.value ?? 1.0
        let final = filtered.max(by: { $0.date < $1.date })?.value ?? 1.0

        return ((final - initial) / initial) * 100
    }
}

#Preview {
    MultiLineChartView(topText: "Monthly Spending: $123.24", allData: [])
}
