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

    @State private var closeButtonOpacity = 0.5

    let gitCommand = "git config --global core.editor \"open -W -a 'CommitEdit'\""
    let messageLength = 72.0
    let horizontalPadding = 10.0

    var body: some View {
        if showWelcomeView {
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
                            systemImage: "document.on.document"
                        ) {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(gitCommand, forType: .string)
                        }
                        .controlSize(.large).padding()
                        Text("After that, commit messages should open for editing here.").padding()
                    }.padding()
                }.defaultScrollAnchor(.center)
                Button(
                    "Close",
                    systemImage: "xmark.circle.fill"
                ) {
                    exit(0)
                }
                .onHover(perform: {hover in
                    withAnimation(.easeOut(duration: 0.2)) {
                        closeButtonOpacity = hover ? 1.0 : 0.5
                        }
                    }
                )
                .font(.system(size: 13))
                .opacity(closeButtonOpacity)
                .buttonStyle(.borderless)
                .labelStyle(.iconOnly)
                .position(x: 17, y: 17)
            }
            .ignoresSafeArea()
            .frame(minWidth: 600, minHeight: 440)
        } else {
            ZStack {
                Color.primary.opacity(0.08).ignoresSafeArea(.all)
                    .offset(
                        CGSize(
                            width: (" ".size(
                                withAttributes: [
                                    .font: NSFont.monospacedSystemFont(
                                        ofSize: NSFont.systemFontSize + 1,
                                        weight: .regular
                                    )
                                ]
                            ).width * (messageLength + 0.5)) + horizontalPadding,
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
                    .padding(.horizontal, horizontalPadding)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        HStack {
                            Button("Cancel") {
                                exit(0)
                            }
                            Button(
                                "Commit",
                                systemImage: "point.topright.arrow.triangle.backward.to.point.bottomleft.scurvepath.fill",
                                action: onCommit
                            )
                            .buttonStyle(.borderedProminent)
                            .labelStyle(.titleAndIcon)
                        }
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(
                            .rect(topLeadingRadius: 12)
                        )
                    }
                    .controlSize(.large)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var text = ""
    @Previewable @State var showWelcomeView = true

    ContentView(showWelcomeView: $showWelcomeView, text: $text, onCommit: {})
}
