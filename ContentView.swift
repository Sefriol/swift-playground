import SwiftUI
import os

struct CarouselFormItemView: View {
    @ObservedObject var exerciseSet: ExerciseSetModel
    var setIdx: Int
    
    var body: some View {
        ForEach(0...Int(exerciseSet.Repetitions ?? 0.0), id: \.self) { skipIdx in
            ForEach(Array(exerciseSet.items.enumerated()), id: \.offset) { exerciseIdx, item in
                if let exercise = item as? ExerciseViewModel {
                    ForEach(Array(exercise.exerciseRounds.enumerated()), id: \.offset) { roundIdx, round in
                        if roundIdx == skipIdx {
                            ExerciseForm(item: exercise, round: round, index: roundIdx, max: exercise.exerciseRounds.count)
                                .tag(TabCoordinate(set: setIdx, exercise: exerciseIdx, round: roundIdx))
                        }
                    }
                } else if let set = item as? ExerciseSetModel {
                    CarouselFormItemView(exerciseSet: set, setIdx: setIdx + 1)
                }
            }
        }
    }
}

struct TabCoordinate: Hashable {
    let set: Int
    let exercise: Int
    let round: Int
}

struct MyPreferenceKey: PreferenceKey {
    static let defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        print(value)
        value += nextValue()
    }
}

struct ContentView: View {
    @Environment(\.logger) var logger
    @State private var listSize: CGFloat = UIScreen.main.bounds.height / 6 * 4
    @State private var tabSize: CGFloat = UIScreen.main.bounds.height / 6 * 2
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
                .onAppear {
                    let id = "\(selectedTab.set)\(selectedTab.exercise)"
                    value.scrollTo(id, anchor: .bottom)
                }
                .onChange(of: listSize) { _ in
                    //logger.info("ListSize Changed")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            value.scrollTo(selectedTab, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: selectedTab) { newValue in
                    withAnimation {
                        let id = "\(selectedTab.set)\(selectedTab.exercise)"
                        value.scrollTo(id, anchor: .center)
                    }
                }
            }
            .frame(height: listSize)
            .animation(.easeInOut(duration: 0.5), value: self.listSize)
            TimeoutBarView()
                .padding(.horizontal, 15)
                .zIndex(3)
                .animation(.easeInOut(duration: 0.5), value: self.listSize)
            VStack(spacing: 0) {
                TabView(selection: $selectedTab) {
                    ForEach(Array(viewModel.enumerated()), id: \.offset) {idx, item in
                        CarouselFormItemView(exerciseSet: item, setIdx: idx)
                    }
                }
                .onPreferenceChange(MyPreferenceKey.self, perform: { value in
                    print("test")
                    print(value)
                })
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never ))
            }
            .shadow(radius: 10)
            .padding(.top, 10)
            .background(Color(UIColor.systemGray6))
            .onTapGesture(count: 2) {
                let temp = self.tabSize
                self.tabSize = self.listSize
                self.listSize = temp
            }
            .zIndex(2)
            .animation(.easeInOut(duration: 0.5), value: self.listSize)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .onAppear() {
            for set in 1...10 {
                let newSet = ExerciseSetModel(name: "Exercise Set \(set)", description: "Random Exercise", repetitions: Double.random(in: 1...3).rounded(), items: [])
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
