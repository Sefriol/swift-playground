//
//  ResizableBottomDrawer.swift
//  playground
//
//  Created by Joakim Järvinen on 7.10.2024.
//
import SwiftUI

struct ResizableBottomDrawer: View {
    @State private var drawerHeight: CGFloat = 300
    @State private var lastDragValue: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                VStack {
                    Capsule()
                        .frame(width: 40, height: 6)
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                    
                    // Content of the drawer
                    Text("Drawer Content")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(radius: 10)
                }
                .frame(height: drawerHeight)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(16)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let dragAmount = value.translation.height - lastDragValue
                            let newHeight = drawerHeight - dragAmount
                            if newHeight > 100 && newHeight < geometry.size.height * 0.9 {
                                drawerHeight = newHeight
                                lastDragValue = value.translation.height
                            }
                        }
                        .onEnded { _ in
                            lastDragValue = 0
                        }
                )
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
