//
//  Commit_Message_EditorApp.swift
//  Commit Message Editor
//
//  Created by kramo on 04-11-2024.
//

import SwiftUI

@main
struct Commit_Message_EditorApp: App {
    @StateObject private var fileHandler = FileHandler()

    var body: some Scene {
        WindowGroup {
            ContentView(text: $fileHandler.text, onCommit: fileHandler.saveFile)
                .onOpenURL { url in
                    fileHandler.loadFile(from: url)
                }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}

class FileHandler: ObservableObject {
    @Published var text: String = "\n# Describe your changes"
    private var fileURL: URL?
    
    func loadFile(from url: URL) {
        do {
            let fileContents = try String(contentsOf: url, encoding: .utf8)
            DispatchQueue.main.async {
                self.text = fileContents
                self.fileURL = url
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
