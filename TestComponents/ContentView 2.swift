//
//  ContentView 2.swift
//  playground
//
//  Created by Joakim Järvinen on 19.10.2024.
//
import SwiftUI

struct ExerciseTableCell: View {
    @ObservedObject var exercise: ExerciseViewModel
    @Binding var selectedTab: TabCoordinate
    var setIdx: Int
    var exerciseIdx: Int
    
    var body: some View {
        let title = Text("\(exercise.name)").font(.caption).bold().frame(maxWidth: .infinity, alignment: .leading)
        if selectedTab.exercise == exerciseIdx && selectedTab.set == setIdx {
            title.underline()
        } else {
            title
        }
        ForEach(Array(exercise.exerciseRounds.enumerated()), id: \.offset) { roundIdx, round in
            let element = VStack {
                let reps = exercise.Repetitions ?? 0
                Text("\(reps.formatted()) sets")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(exercise.Weight.formatted())\(exercise.unit)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }.frame(maxWidth: .infinity, alignment: .center)
                .id("\(setIdx)\(exerciseIdx)\(roundIdx)")
                .onTapGesture {
                    withAnimation {
                        print("Tap \(setIdx),\(exerciseIdx),\(roundIdx)")
                        selectedTab = TabCoordinate(set: setIdx, exercise: exerciseIdx, round: roundIdx)
                    }
                }
            if selectedTab.exercise == exerciseIdx && selectedTab.set == setIdx && selectedTab.round == roundIdx {
                element.background(Color.gray.opacity(0.2))
                    .foregroundColor(.primary)
            } else {
                element
            }
        }
    }
}


struct ExerciseSetListItemNew: View {
    @ObservedObject var item: ExerciseModel
    @Binding var selectedTab: TabCoordinate
    @State private var isExpanded: Bool = false
    var setIdx: Int
    var idx: Int
    
    var body: some View {
        if let exercise = item as? ExerciseViewModel {
            GridRow {
                let element = ExerciseTableCell(exercise: exercise, selectedTab: $selectedTab, setIdx: setIdx, exerciseIdx: idx)
                .onTapGesture {
                    withAnimation {
                        selectedTab = TabCoordinate(set: setIdx, exercise: idx, round: 0)
                    }
                }
                .id("\(setIdx)\(idx)")
                if selectedTab.exercise == idx && selectedTab.set == setIdx {
                    element
                        .bold()
                } else {
                    element
                }
            }
        } else if let set = item as? ExerciseSetModel {
            DisclosureGroup(
                isExpanded: Binding(
                    get: {
                        print("\(set.name) \(selectedTab.exercise)==\(idx) && \(selectedTab.set) == \(setIdx)")
                        return isExpanded || (selectedTab.set == setIdx) },
                    set: { newValue in
                        isExpanded = newValue
                    }
                ),
                content: {
                    Grid(alignment: .center, horizontalSpacing: 0, verticalSpacing: 0) {
                        GridRow {
                            Divider()
                            ForEach(1...Int(set.Repetitions ?? 0), id: \.self) { roundIdx in
                                Text("\(roundIdx)").font(.callout).bold().frame(maxWidth: .infinity, alignment: .center)
                                
                            }
                        }
                        .overlay(Rectangle().frame(height: 1), alignment: .bottom)
                        
                        ForEach(Array(set.items.enumerated()), id: \.element.id) { exerciseIdx, setItem in
                            ExerciseSetListItemNew(item: setItem, selectedTab: $selectedTab, setIdx: setIdx, idx: exerciseIdx)
                            
                        }
                    }

                },
                label: {
                    let reps = set.Repetitions ?? 1
                    Text("\(set.name),  \(reps.formatted()) round\(Int(reps.formatted()) == 1 ? "" : "s")")
                }
            )
            .onAppear {
                if selectedTab.exercise == idx && selectedTab.set == setIdx {
                    isExpanded = true
                }
            }
            .onChange(of: selectedTab) { newValue in
                if newValue.exercise == idx && newValue.set == setIdx {
                    isExpanded = true
                } else {
                    isExpanded = false
                }
            }
        }
    }
}
struct ExerciseListTable: View {
    @State private var viewModel: [ExerciseSetModel] = []
    @State private var selectedTab: TabCoordinate = TabCoordinate(set: 0, exercise: 0, round: 0)
    
    var body: some View {
        VStack(spacing: -10){
            ScrollViewReader { value in
                List() {
                    ForEach(Array(viewModel.enumerated()), id: \.offset) {idx, item in
                        ExerciseSetListItemNew(item: item, selectedTab: $selectedTab, setIdx: idx, idx: 0)
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button(role: .destructive) { } label: {
                                    Label("Read", systemImage: "xmark")
                                }
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button() {} label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                            }
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .onAppear() {
            for set in 1...10 {
                let newSet = ExerciseSetModel(name: "Exercise Set \(set)", description: "Random Exercise", repetitions: Double.random(in: 1...4).rounded(), items: [])
                for exercise in 1...5 {
                    let newExercise = ExerciseViewModel(parent: newSet,
                        name: "Exercise \(exercise)", description: "Random Exercise", unit: "kg", weight: Double.random(in: 1...200).rounded(), repetitions: Double.random(in: 5...15).rounded())
                    newSet.addExercise(newExercise)
                    if Double.random(in: 0...1) < 0.3 {
                        break
                    }
                }
                viewModel.append(newSet)
            }
        }
    }
}


struct ExerciseListTableView: View {
    var body: some View {
        ExerciseListTable()
    }
}

struct ExerciseListTableView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseListTableView()
    }
}
