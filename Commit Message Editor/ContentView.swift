//
//  ContentView.swift
//  Commit Message Editor
//
//  Created by kramo on 04-11-2024.
//

import SwiftUI

struct ContentView: View {
    @Binding var fileOpened: Bool
    @Binding var text: String
    let onCommit: () -> Void
    
    var gitCommand = "git config --global core.editor \"open -W -a 'Commit Message Editor'\""

    var body: some View {
        if fileOpened {
            TextEditor(text: $text).font(.system(.body, design: .monospaced))
                .scrollContentBackground(.hidden)
                .padding()
                .toolbar {
                    ToolbarItem() {
                        Spacer()
                    }
                    ToolbarItem() {
                        Button(
                            "Commit",
                            systemImage: "point.topright.arrow.triangle.backward.to.point.bottomleft.scurvepath.fill",
                            action: onCommit
                        ).labelStyle(.titleAndIcon)
                    }
                }
        } else {
            ZStack {
                Color.clear.background(.ultraThinMaterial)
                ScrollView {
                    VStack {
                        Text("Setting Up").font(.title).padding()
                        Text("Run the following in the Terminal:").font(.title2)
                        Text(gitCommand).font(.system(.headline, design: .monospaced)).padding(5).background(Color.black).foregroundColor(Color.white).cornerRadius(5)
                            .opacity(0.8)
                        Button(
                            "Copy Command",
                            systemImage: "document.on.document",
                            action: {
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setString(gitCommand, forType: .string)
                            }
                        ).controlSize(.large).padding()
                        Text("After that, commit messages should open for editing here.").padding()
                    }.padding()
                }.defaultScrollAnchor(.center)
            }
        }
    }
}

#Preview {
    @Previewable @State var text = "\n# Describe your changes"
    @Previewable @State var fileOpened = false

    ContentView(fileOpened: $fileOpened, text: $text, onCommit: {})
}
