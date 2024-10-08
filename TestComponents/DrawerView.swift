//
//  DrawerView.swift
//  playground
//
//  Created by Joakim Järvinen on 7.10.2024.
//
import SwiftUI

@available(iOS 17.0, *)
struct DrawerContentView: View {
    @ObservedObject var viewModel: ExerciseSetModel
    
    var body: some View {
        Text("Drawer")
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach(viewModel.flatList) { item in
                    let bindingItem = Binding<ExerciseModel>(
                        get: { item },
                        set: {
                            item.Repetitions = $0.Repetitions
                            //item.Weight = $0.Weight
                        }
                    )
                    //ExerciseForm(item: bindingItem)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        Text("Drawer End")
    }
}
