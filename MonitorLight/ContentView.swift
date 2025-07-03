//
//  ContentView.swift
//  MonitorLight
//
//  Created by Anthony CYY on 3/7/2025.
//

import SwiftUI

extension Color {
    // Convert Color to hex string
    func toHex() -> String? {
        let uiColor = NSColor(self)
        guard let rgbColor = uiColor.usingColorSpace(.deviceRGB) else { return nil }
        let red = Int(rgbColor.redComponent * 255)
        let green = Int(rgbColor.greenComponent * 255)
        let blue = Int(rgbColor.blueComponent * 255)
        return String(format: "%02X%02X%02X", red, green, blue)
    }
    // Create Color from hex string
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

// Custom button style for always-black text
struct BlackTextButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.black)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
            .opacity(configuration.isPressed ? 0.6 : 1.0)
    }
}

struct ContentView: View {
    @AppStorage("colorHex") private var colorHex: String = "FFFFFF"
    @AppStorage("brightness") private var brightness: Double = 1.0
    @State private var color: Color = .white
    @State private var isFullScreen = false
    @State private var showControlPanel = true
    @State private var hidePanelWorkItem: DispatchWorkItem?
    var body: some View {
        ZStack {
            color.opacity(brightness)
                .ignoresSafeArea()
            if showControlPanel {
                VStack {
                    ColorPicker("Pick a color", selection: $color)
                        .padding()
                        .foregroundColor(.black)
                    HStack {
                        Text("Brightness")
                            .foregroundColor(.black)
                        Slider(value: $brightness, in: 0...1)
                            .accentColor(.blue)
                    }
                    .padding()
                    Button(isFullScreen ? "Exit Full Screen (Esc)" : "Go Full Screen") {
                        toggleFullScreen()
                    }
                    .buttonStyle(BlackTextButtonStyle())
                    .padding(.bottom, 24)
                }
                .background(Color.white.opacity(0.8))
                .cornerRadius(12)
                .padding()
                .frame(maxWidth: 350)
            }
        }
        .onAppear {
            if let loadedColor = Color(hex: colorHex) {
                color = loadedColor
            }
            NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .mouseMoved, .leftMouseDown, .rightMouseDown, .otherMouseDown]) { event in
                resetHidePanelTimer()
                if event.type == .keyDown && event.keyCode == 53 { // Esc key
                    if isFullScreen {
                        toggleFullScreen()
                        return nil
                    }
                }
                return event
            }
            resetHidePanelTimer()
        }
        .onChange(of: color) { newColor in
            if let hex = newColor.toHex() {
                colorHex = hex
            }
        }
        .onChange(of: showControlPanel) { visible in
            if visible {
                NSCursor.unhide()
            } else {
                NSCursor.hide()
            }
        }
    }
    private func resetHidePanelTimer() {
        showControlPanel = true
        hidePanelWorkItem?.cancel()
        let workItem = DispatchWorkItem {
            withAnimation {
                showControlPanel = false
            }
        }
        hidePanelWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: workItem)
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
