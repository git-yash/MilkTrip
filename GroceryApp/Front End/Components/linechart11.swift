import SwiftUI
import Charts

enum LineChartType: String, CaseIterable, Plottable {
    case optimal = "Optimal"
    case outside = "Outside range"
    
    var color: Color {
        switch self {
        case .optimal: return .green
        case .outside: return .blue
        }
    }
    
}

struct LineChartData {
    
    var id = UUID()
    var date: Date
    var value: Double
    
    var type: LineChartType
}

struct LineChartView: View {
    
    let data: [ LineChartData]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Line Chart")
                .font(.system(size: 16, weight: .medium))
            
            Chart {
                ForEach(data, id: \.id) { item in
                    LineMark(
                        x: .value("Weekday", item.date),
                        y: .value("Value", item.value)
                    )
                    
                    .foregroundStyle(item.type.color)
                    
                    .foregroundStyle(by: .value("Plot", item.type))
                    .interpolationMethod(.catmullRom)
                    .lineStyle(.init(lineWidth: 2))
                    .symbol {
                        Circle()
                            .fill(item.type.color)
                            .frame(width: 12, height: 12)
                            .overlay {
                                Text("\(Int(item.value))")
                                    .frame(width: 20)
                                    .font(.system(size: 8, weight: .medium))
                                    .offset(y: -15)
                            }
                    }
                }
            }
            .chartLegend(position: .top, alignment: .leading, spacing: 24){
                HStack(spacing: 6) {
                    ForEach(LineChartType.allCases, id: \.self) { type in
                        Circle()
                            .fill(type.color)
                            .frame(width: 8, height: 8)
                        Text(type.rawValue)
                            .foregroundStyle(type.color)
                            .font(.system(size: 11, weight: .medium))
                    }
                }
            }
            .chartXAxis {
                AxisMarks(preset: .extended, values: .stride (by: .month)) { value in
                    AxisValueLabel(format: .dateTime.month())
                }
            }
            .chartYAxis {
                AxisMarks(preset: .extended, position: .leading, values: .stride(by: 5))
            }
            
        }
        .frame(height: 360)
    }
}

var chartData : [LineChartData] = {
    let sampleDate = Date().startOfDay.adding(.month, value: -10)!
    var temp = [LineChartData]()
    
    // Line 1
    for i in 0..<8 {
        let value = Double.random(in: 5...20)
        temp.append(
            LineChartData(
                date: sampleDate.adding(.month, value: i)!,
                value: value,
                type: .outside
            )
        )
    }
    
    // Line 2
    for i in 0..<8 {
        let value = Double.random(in: 5...20)
        temp.append(
            LineChartData(
                date: sampleDate.adding(.month, value: i)!,
                value: value,
                type: .optimal
            )
        )
    }
    
    return temp
}()


#Preview {
    VStack {
        Spacer()
        LineChartView(data: chartData)
            .padding()
        Spacer()
    }
}

extension Date {
    func adding (_ component: Calendar.Component, value: Int, using calendar: Calendar = .current) -> Date? {
        return calendar.date(byAdding: component, value: value, to: self)
    }

    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}
