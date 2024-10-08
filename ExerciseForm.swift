//
//  ExerciseForm.swift
//  playground
//
//  Created by Joakim Järvinen on 7.10.2024.
//
import SwiftUI
import YouTubePlayerKit
import Charts

struct ExerciseForm: View {
    @ObservedObject var item: ExerciseViewModel
    @ObservedObject var round: ExerciseRoundModel
    @State var test: String = ""
    var index: Int
    var max: Int
    @State var exerciseData: [ExerciseRoundModel] = []
    
    func getRounds() -> [ExerciseRoundModel] {
        [
            ExerciseRoundModel(parent: item, weight: 50, repetitions: 10, date: Date().addingTimeInterval(-86400 * 4)),
            ExerciseRoundModel(parent: item, weight: 55, repetitions: 12, date: Date().addingTimeInterval(-86400 * 3)),
            ExerciseRoundModel(parent: item, weight: 60, repetitions: 8, date: Date().addingTimeInterval(-86400 * 2)),
            ExerciseRoundModel(parent: item, weight: 65, repetitions: 15, date: Date().addingTimeInterval(-86400 * 1)),
            ExerciseRoundModel(parent: item, weight: 70, repetitions: 10, date: Date()),
        ]
    }
    func getTitle(exercise: ExerciseViewModel) -> String {
        if (exercise.parent != nil) {
            return "\(exercise.parent!.name): \t \(exercise.name) \t Round \(index + 1)/\(max)"
        }
        return item.name
    }
    func getRoundInfo(roundIdx: Int) -> String {
        self.item.exerciseRounds[roundIdx].description
    }
    
    func getButtonColor() -> Color {
        round.Completed ? .secondary : .green
    }
    
    func getButtonText() -> String {
        if (round.Completed) {
            return "Completed"
        }
        if round.Weight == nil || round.Repetitions == nil {
            return "Autofill + Complete"
        } else {
            return "Complete"
        }
    }
    
    func completeRound() {
        if (round.Weight == nil) {
            round.Weight = item.Weight
        }
        if (round.Repetitions == nil) {
            round.Repetitions = item.Repetitions
        }
        round.complete()
    }
    
    var body: some View {
        Form() {
            Section(header: Text(getTitle(exercise: item))) {
                HStack {
                    ZStack {
                        TextField("Reps", value: $round.Repetitions, format: .number)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(size: 24))
                            .frame(height: 50)
                            .padding(.horizontal, 5)
                            .disabled(round.Completed)
                        Text("reps")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.leading, 105)
                            .padding(.top, -15)
                            .zIndex(1)
                    }
                    ZStack {
                        TextField("Weight", value: $round.Weight, format: .number)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 24))
                            .frame(height: 50)
                            .padding(.horizontal, 5)
                            .disabled(round.Completed)
                        Text("\(item.unit)")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.leading, 115)
                            .padding(.top, -15)
                            .zIndex(1)
                    }
                }
                Button(action: {
                    print("Complete button pressed. Status  \(round.Completed)")
                    test = "test\(index)\(max)"
                    completeRound()
                }) {
                    HStack(alignment: .center) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(getButtonColor())
                        Text(getButtonText()).font(.largeTitle)
                    }.frame(width: UIScreen.main.bounds.width)
                }
                .disabled(round.Completed)
                .preference(key: MyPreferenceKey.self,
                            value: test)
            }
            Section("Exercise Details") {
                Text($item.description.wrappedValue.isEmpty ? "No description" : $item.description.wrappedValue)
                YouTubePlayerView(
                    "https://youtube.com/watch?v=psL_5RIBqnY"
                ).frame(height: UIScreen.main.bounds.height / 4)
                Section("Exercise Progress") {
                 NormilizedLineChart(exerciseData: $exerciseData)
                    .frame(height: UIScreen.main.bounds.height / 4)
                    .onAppear {
                        exerciseData.append(contentsOf: getRounds())
                    }
                    
                }
           }
        }
    }
}
