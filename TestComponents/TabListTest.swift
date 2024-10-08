//
//  ContentView 2.swift
//  playground
//
//  Created by Joakim Järvinen on 17.10.2024.
//




import SwiftUI

struct ListView: View {
    @Binding var selectedTab: Int

    var body: some View {
        List {
            Button("Go to Tab 1") {
                withAnimation {
                    selectedTab = 0
                }
            }
            Button("Go to Tab 2") {
                withAnimation {
                    selectedTab = 1
                }
            }
            // Add more buttons for additional tabs
        }
    }
}

struct TabListTest: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        VStack {
            ListView(selectedTab: $selectedTab)
            TabView(selection: $selectedTab) {
                Text("Tab 1 Content")
                    .tabItem {
                        Label("Tab 1", systemImage: "1.circle")
                    }
                    .tag(0)
                Text("Tab 2 Content")
                    .tabItem {
                        Label("Tab 2", systemImage: "2.circle")
                    }
                    .tag(1)
                // Add more tabs as needed
            }
        }
    }
}

struct TLView: View {
    var body: some View {
        TabListTest()
    }
}

struct TLView_Previews: PreviewProvider {
    static var previews: some View {
        TLView()
    }
}
