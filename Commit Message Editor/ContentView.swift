//
//  ContentView.swift
//  Commit Message Editor
//
//  Created by kramo on 04-11-2024.
//

import SwiftUI

struct ContentView: View {
    @Binding var text: String
    let onCommit: () -> Void

    var body: some View {
    TextEditor(text: $text).font(.system(.body, design: .monospaced))
        .scrollContentBackground(.hidden)
        .padding()
        .toolbar {
            ToolbarItem() {
              Spacer()
            }
            ToolbarItem() {
                Button("Commit", action: onCommit)
            }
        }
    }
}

#Preview {
    @Previewable @State var text = "\n# Describe your changes"

    ContentView(text: $text, onCommit: {})
}
