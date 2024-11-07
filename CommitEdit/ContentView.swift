//
//  ContentView.swift
//  CommitEdit
//
//  Created by kramo on 04-11-2024.
//

import SwiftUI

struct ContentView: View {
    @Binding var showWelcomeView: Bool
    @Binding var text: String
    let onCommit: () -> Void

    var body: some View {
        if showWelcomeView {
            WelcomeView()
        } else {
            EditorView(text: $text, onCommit: onCommit)
        }
    }
}

#Preview {
    @Previewable @State var text = ""
    @Previewable @State var showWelcomeView = true

    ContentView(showWelcomeView: $showWelcomeView, text: $text, onCommit: {})
}
