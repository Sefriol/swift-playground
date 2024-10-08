//
//  ContentView 3.swift
//  playground
//
//  Created by Joakim Järvinen on 23.10.2024.
//


import SwiftUI
import Charts

struct CharView : View {
    let data1 = [
        (x: 1, y: 2),
        (x: 2, y: 4),
        (x: 3, y: 6)
    ]
    
    let data2 = [
        (x: 1, y: 3),
        (x: 2, y: 5),
        (x: 3, y: 7)
    ]
    
    var body: some View {
        Chart {
            ForEach(data1, id: \.x) { point in
                LineMark(
                    x: .value("X Axis", point.x),
                    y: .value("Y Axis", point.y),
                    series: .value("Data", "1")
                )
                .foregroundStyle(.blue)
                .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
            }
            .lineStyle(StrokeStyle(lineWidth: 4.0))
            .interpolationMethod(.catmullRom)

            ForEach(data2, id: \.x) { point in
                LineMark(
                    x: .value("X Axis", point.x),
                    y: .value("Y Axis", point.y),
                    series: .value("Data", "2")
                )
                .foregroundStyle(.red)
                .lineStyle(StrokeStyle(lineWidth: 2, dash: [2, 2]))
            }
            .lineStyle(StrokeStyle(lineWidth: 4.0))
            .interpolationMethod(.catmullRom)
        }
        .frame(height: 300)
    }

}

struct CharView_Previews: PreviewProvider {
    static var previews: some View {
        CharView()
    }
}
