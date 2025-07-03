//
//  MonitorLightApp.swift
//  MonitorLight
//
//  Created by Anthony CYY on 3/7/2025.
//

import SwiftUI
import IOKit.pwr_mgt

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
    var assertionID: IOPMAssertionID = 0
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        // Prevent system sleep/screensaver
        let reasonForActivity = "MonitorLight prevents sleep while running" as CFString
        IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep as CFString,
                                    IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                    reasonForActivity,
                                    &assertionID)
        // Enter full screen after a short delay to ensure window is available
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let window = NSApp.windows.first {
                window.toggleFullScreen(nil)
            }
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        // Release the assertion
        IOPMAssertionRelease(assertionID)
    }
}
