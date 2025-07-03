import SwiftUI

@main
struct MonitorLightApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 400, minHeight: 300)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
    }
}

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