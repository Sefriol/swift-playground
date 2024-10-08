//
//  TotalWidthKey.swift
//  playground
//
//  Created by Joakim Järvinen on 27.10.2024.
//
import SwiftUI

struct TotalWidthKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct ParentChildView: View {
    @State var extra: CGFloat = 0
    var body: some View {
        ChildView()
        Button("Add Extra", action: { self.extra = self.extra + 1 })
            .preference(key: TotalWidthKey.self, value: extra)
            
    }
}

struct ChildView: View {
    var body: some View {
        Text("Child View")
            .padding()
            .background(GeometryReader { geometry in
                Color.clear.preference(key: TotalWidthKey.self, value: geometry.size.width)
            })
    }
}

struct ChildViewTwo: View {
    var body: some View {
        Text("Child View Two")
            .padding()
            .background(GeometryReader { geometry in
                Color.clear.preference(key: TotalWidthKey.self, value: geometry.size.width)
            })
    }
}

struct ChildViewThree: View {
    var body: some View {
        Text("Child View Three")
            .padding()
            .background(GeometryReader { geometry in
                Color.clear.preference(key: TotalWidthKey.self, value: geometry.size.width)
            })
    }
}

struct ParentView: View {
    @State private var totalWidth: CGFloat = 0
    
    var body: some View {
        VStack {
            ParentChildView()
            //ChildView()
            ChildViewTwo()
            ChildViewThree()
            Text("Total Width: \(totalWidth)")
        }
        .onPreferenceChange(TotalWidthKey.self) { value in
            print(value)
            self.totalWidth = value
        }
    }
}

struct ParentView_Previews: PreviewProvider {
    static var previews: some View {
        ParentView()
    }
}
