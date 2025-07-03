//
//  ContentView.swift
//  MonitorLight
//
//  Created by Anthony CYY on 3/7/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var color: Color = .white
    @State private var isFullScreen = false
    var body: some View {
        ZStack {
            color
                .ignoresSafeArea()
            VStack {
                ColorPicker("Pick a color", selection: $color)
                    .padding()
                Button(isFullScreen ? "Exit Full Screen (Esc)" : "Go Full Screen") {
                    toggleFullScreen()
                }
                .padding()
            }
            .background(Color.white.opacity(0.8))
            .cornerRadius(12)
            .padding()
        }
        .onAppear {
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                if event.keyCode == 53 { // Esc key
                    if isFullScreen {
                        toggleFullScreen()
                        return nil
                    }
                }
                return event
            }
        }
    }
    private func toggleFullScreen() {
        if let window = NSApplication.shared.windows.first {
            window.toggleFullScreen(nil)
            isFullScreen.toggle()
        }
    }
} 

#Preview {
    ContentView()
}
