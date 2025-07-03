# MonitorLight

MonitorLight is a simple macOS application that turns your computer monitor into a customizable light source. It is useful for photography, video calls, ambient lighting, or any scenario where you need a bright, solid color from your screen.

## Features
- Full-screen solid color light mode
- Color picker to choose any color
- Quick toggle between windowed and full-screen mode
- Exit full-screen mode with the Esc key
- Lightweight and privacy-friendly

## Requirements
- macOS 12 Monterey or later
- Swift 5.7+

## Setup & Usage
1. **Clone the repository:**
   ```sh
   git clone <your-repo-url>
   cd MonitorLight
   ```
2. **Open in Xcode:**
   - Open `Package.swift` in Xcode.
3. **Build and Run:**
   - Select the MonitorLight scheme and run the app.

## How to Use
- Use the color picker to select your desired light color.
- Click "Go Full Screen" to fill your monitor with the color.
- Press `Esc` to exit full-screen mode.

## Roadmap / Planned Features
- Menu bar quick access
- Multi-monitor support
- Preset color options
- Timer and fade effects

## Build & Deliver with Script

You can build and deliver the app from the command line:

1. **Build the app:**
   ```sh
   xcodebuild -scheme MonitorLight -configuration Release -derivedDataPath build
   ```
   This will generate the `.app` bundle at `build/Build/Products/Release/MonitorLight.app`.

2. **Deliver (open the build folder in Finder):**
   ```sh
   open build/Build/Products/Release
   ```
   This will open the folder containing the built app so you can run or distribute it.

## License
MIT License 