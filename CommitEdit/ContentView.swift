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
    let onAbort: () -> Void

    var body: some View {
        VStack {
            if !showWelcomeView {
                WelcomeView()
            } else {
                EditorView(
                    text: $text,
                    onCommit: onCommit,
                    onAbort: onAbort
                )
            }
        }.animation(
            .easeOut(duration: 0.2),
            value: showWelcomeView
        )
    }
}

#Preview {
    @Previewable @State var text = ""
    @Previewable @State var showWelcomeView = true
    
    ContentView(
        showWelcomeView: $showWelcomeView,
        text: $text,
        onCommit: {},
        onAbort: {}
    )
}
