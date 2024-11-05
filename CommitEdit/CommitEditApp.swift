//
//  CommitEditApp.swift
//  CommitEdit
//
//  Created by kramo on 04-11-2024.
//

import SwiftUI

@main
struct CommitEditApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var fileHandler = FileHandler()

    var body: some Scene {
        WindowGroup {
            ContentView(fileOpened: $fileHandler.fileOpened,
                        text: $fileHandler.text,
                        onCommit: {
                            fileHandler.saveFile()
                            exit(0)
                        }
            ).onOpenURL { url in
                fileHandler.loadFile(from: url)
            }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .windowResizability(.contentSize)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    func applicationWillFinishLaunching(_ notification: Notification) {
            NSWindow.allowsAutomaticWindowTabbing = false
    }
}


class FileHandler: ObservableObject {
    @Published var fileOpened: Bool = false
    @Published var text: String = "\n# Describe your changes"
    private var fileURL: URL?

    func loadFile(from url: URL) {
        do {
            let fileContents = try String(contentsOf: url, encoding: .utf8)
            DispatchQueue.main.async {
                self.text = fileContents
                self.fileURL = url
                self.fileOpened = true
            }
        } catch {}
    }

    func saveFile() {
        guard let fileURL = fileURL else { return }
        do {
            try text.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {}
    }
}
