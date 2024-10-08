import SwiftUI
import YouTubePlayerKit
import Charts

struct NormilizedLineChart: View {
    @Binding var exerciseData: [ExerciseRoundModel]
    
    func normalize(_ value: Double, min: Double, max: Double) -> Double {
        return (value - min) / (max - min)
    }
    
    var body: some View {
        let weights = exerciseData.compactMap { $0.Weight }
        let repetitions = exerciseData.compactMap { $0.Repetitions }
        
        let minWeight = weights.min() ?? 0
        let maxWeight = weights.max() ?? 1
        let minRepetitions = repetitions.min() ?? 0
        let maxRepetitions = repetitions.max() ?? 1
        Chart {
            ForEach(exerciseData) { item in
                LineMark(
                    x: .value("Date", item.Date!),
                    y: .value("Weight", normalize(item.Weight ?? 0, min: minWeight, max: maxWeight)),
                    series: .value("Value", "Weight")
                )
                .foregroundStyle(.purple)
                .lineStyle(StrokeStyle(lineWidth: 1.0, dash: [5, 5]))
                
                PointMark(
                    x: .value("Date", item.Date!),
                    y: .value("Weight", normalize(item.Weight ?? 0, min: minWeight, max: maxWeight))
                ).foregroundStyle(.purple)
            
                LineMark(
                    x: .value("Date", item.Date!),
                    y: .value("Repetitions", normalize(item.Repetitions ?? 0, min: minRepetitions, max: maxRepetitions)),
                    series: .value("Value", "Reps")
                )
                .foregroundStyle(.teal)
                .lineStyle(StrokeStyle(lineWidth: 1.0, dash: [2, 2]))
                
                PointMark(
                    x: .value("Date", item.Date!),
                    y: .value("Repetitions", normalize(item.Repetitions ?? 0, min: minRepetitions, max: maxRepetitions))
                ).foregroundStyle(.teal)
            }
        }
        .chartForegroundStyleScale([
            "Weight": .purple,
            "Reps": .teal
        ])
        .chartYAxis {
            AxisMarks(position: .leading, values: Array(stride(from: 0.0, through: 1.0, by: 0.5))) {axis in
                AxisGridLine()
                AxisTick()
                AxisValueLabel (
                    "\(((axis.as(Double.self) ?? 0.0) * (maxWeight - minWeight) + minWeight).formatted())").foregroundStyle(.purple)
            }
            AxisMarks(position: .trailing, values: Array(stride(from: 0.0, through: 1.0, by: 0.5))) {axis in
                AxisGridLine()
                AxisTick()
                AxisValueLabel (
                    "\(((axis.as(Double.self) ?? 0.0) * (maxRepetitions - minRepetitions) + minRepetitions).formatted())").foregroundStyle(.teal)
            }
        }
        .chartXAxis {
            AxisMarks(position: .bottom) {
                _ in
                AxisTick()
                //AxisGridLine()
            }
        }
    }
}

struct NormilizedLineChartTests: View {
    @State var exerciseData: [ExerciseRoundModel] = []
    let item = ExerciseViewModel(parent: ExerciseSetModel(name: "Squat Set", items: []), name: "Squat")
    func getRounds() -> [ExerciseRoundModel] {
        return [
            ExerciseRoundModel(parent: item, weight: 50, repetitions: 10, date: Date().addingTimeInterval(-86400 * 4)),
            ExerciseRoundModel(parent: item, weight: 55, repetitions: 12, date: Date().addingTimeInterval(-86400 * 3)),
            ExerciseRoundModel(parent: item, weight: 60, repetitions: 8, date: Date().addingTimeInterval(-86400 * 2)),
            ExerciseRoundModel(parent: item, weight: 65, repetitions: 15, date: Date().addingTimeInterval(-86400 * 1)),
            ExerciseRoundModel(parent: item, weight: 70, repetitions: 10, date: Date()),
        ]
    }
    
    var body : some View {
        VStack {
            NormilizedLineChart(exerciseData: $exerciseData)
                .onAppear {
                    exerciseData = getRounds()
                }
            Button(action: {
                // Update the data
                exerciseData.insert(ExerciseRoundModel(parent: item, weight: 40, repetitions: 10, date: Date().addingTimeInterval(-86400 * 5)), at: 0
                )
            }) {
                Text("Add Data")
            }
        }
    }
}

struct NormilizedLineChart_Previews: PreviewProvider {
    static var previews: some View {
        NormilizedLineChartTests()
    }
}
