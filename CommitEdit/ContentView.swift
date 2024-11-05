//
//  ContentView.swift
//  CommitEdit
//
//  Created by kramo on 04-11-2024.
//

import SwiftUI

struct ContentView: View {
    @Binding var fileOpened: Bool
    @Binding var text: String
    let onCommit: () -> Void

    var gitCommand = "git config --global core.editor \"open -W -a 'CommitEdit'\""

    var body: some View {
        if fileOpened {
            ZStack {
                Color.primary.opacity(0.08).ignoresSafeArea(.all)
                .offset(
                    CGSize(
                        width: " ".size(
                            withAttributes: [
                                .font: NSFont.monospacedSystemFont(
                                    ofSize: NSFont.systemFontSize + 1,
                                    weight: .regular
                                )
                            ]
                        ).width * 72.5,
                        height: 0
                    )
                )
                TextEditor(text: $text)
                    .font(
                        .system(
                            size: NSFont.systemFontSize + 1,
                            weight: .regular,
                            design: .monospaced
                        )
                    )
                    .lineSpacing(3)
                    .scrollContentBackground(.hidden)
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
            }
        } else {
            ZStack {
                Color.clear.background(.ultraThinMaterial)
                ScrollView {
                    VStack {
                        if let appIcon = NSImage(named: NSImage.applicationIconName) {
                            Image(nsImage: appIcon)
                                .resizable()
                                .frame(width: 150, height: 150)
                                .shadow(color: Color.blue.opacity(0.3), radius: 30)
                        }
                        Text("CommitEdit").font(.largeTitle).fontWeight(.bold).padding()
                        Text("Run the following in the Terminal:").font(.title2)
                        Text(gitCommand).font(.system(.headline, design: .monospaced)).padding(5).background(Color.black.opacity(0.6)).foregroundColor(Color.white).cornerRadius(5)
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
            }.frame(minWidth: 600, minHeight: 450)
        }
    }
}

#Preview {
    @Previewable @State var text = "\n# Describe your changes"
    @Previewable @State var fileOpened = true

    ContentView(fileOpened: $fileOpened, text: $text, onCommit: {})
}
