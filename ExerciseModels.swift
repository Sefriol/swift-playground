//
//  AudioPlayerViewModel.swift
//  playground
//
//  Created by Joakim Järvinen on 7.10.2024.
//


import SwiftUI


class ExerciseModel: Identifiable, ObservableObject {
    var id: Self { self }
    @Published var name: String
    @Published var Repetitions: Double?
    @Published var description: String
    weak var parent: ExerciseSetModel?
    
    init(name: String, description: String? = nil, repetitions: Double? = nil) {
        self.name = name
        self.description = description ?? ""
        self.Repetitions = repetitions
    }
}

class ExerciseSetModel: ExerciseModel {
    @Published var items: [ExerciseModel]
    
    init(name: String, description: String? = nil, unit: String? = nil, repetitions: Double? = 1, items: [ExerciseModel]) {
        self.items = items
        super.init(name: name, description: description, repetitions: repetitions)
    }
    
    func addExercise(_ exercise: ExerciseViewModel) {
        exercise.parent = self
        items.append(exercise)
    }
    
    func addExerciseSet(_ set: ExerciseSetModel) {
        items.append(set)
    }
    
    var flatList: [ExerciseViewModel] {
        var allExercises: [ExerciseViewModel] = []
        for item in items {
            if let exercise = item as? ExerciseViewModel {
                var max = Int(exercise.Repetitions?.rounded() ?? 0.0)
                for _ in 1...Int(max) {
                    allExercises.append(exercise)
                }
            } else if let exerciseSet = item as? ExerciseSetModel {
                allExercises.append(contentsOf: exerciseSet.flatList)
            }
        }
        
        return allExercises
    }
}

class ExerciseViewModel: ExerciseModel {
    var index: Int = 0
    @Published var Weight: Double = 0
    @Published var unit: String
    @Published var tags: [String] = []
    @Published var exerciseRounds: [ExerciseRoundModel] = []
    
    init(parent: ExerciseSetModel, name: String, description: String? = nil, unit: String? = nil, weight: Double? = nil, repetitions: Double? = nil, tags: [String]? = nil, exerciseRounds: [ExerciseRoundModel]? = nil) {
        self.unit = unit ?? ""
        self.Weight = weight ?? 0
        self.tags = tags ?? []
        super.init(name: name, description: description, repetitions: repetitions)
        self.parent = parent
        let roundDiff = self.parent?.Repetitions ?? 0 - Double(exerciseRounds?.count ?? 0)
        if exerciseRounds == nil || roundDiff > 0 {
            addRounds(max: roundDiff)
        } else {
            self.exerciseRounds = exerciseRounds!
        }
    }
    
    private func addRounds(max: Double = 0) {
        for _ in 0..<Int(self.parent?.Repetitions ?? max) {
            addRound()
        }
    }
    var completedRounds: Int {
        exerciseRounds.filter { $0.Completed == true }.count
    }
    
    func addRound() {
        exerciseRounds.append(ExerciseRoundModel(parent: self))
    }
}

class ExerciseRoundModel: ExerciseModel {
    @Published var Weight: Double?
    @Published var Completed: Bool = false
    @Published var Date: Date?
    
    init(parent: ExerciseViewModel, weight: Double? = nil, repetitions: Double? = nil, date: Date? = nil) {
        if date != nil {
            Completed = true
            self.Date = date
        }
        Weight = weight
        super.init(name: parent.name, repetitions: repetitions)
    }
    
    func complete() {
        Completed = true
        Date = Foundation.Date()
    }
}

