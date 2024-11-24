//
//  EditorView.swift
//  CommitEdit
//
//  Created by kramo on 07-11-2024.
//


import SwiftUI

struct EditorView: View {
    @Binding var text: String
    let onCommit: () -> Void

    @State private var tooLong: Bool = false
    @State private var showLengthTip: Bool = false

    let messageLength = 50.0
    let descLength = 72.0
    let horizontalPadding = 20.0
    let fontSize = NSFont.systemFontSize + 1

    private func currentMessageLength() -> Int {
        if let message = text.split(separator: "\n").first(where: {
            !$0.trimmingCharacters(in: .whitespaces).hasPrefix("#")
        }) { return message.count } else { return 0 }
    }

    var body: some View {
        ZStack {
            Color.primary.opacity(0.08)
                .offset(
                    CGSize(
                        width: (" ".size(
                            withAttributes: [
                                .font: NSFont.monospacedSystemFont(
                                    ofSize: fontSize,
                                    weight: .regular
                                )
                            ]
                        ).width * (descLength + 0.5)) + horizontalPadding,
                        height: 0
                    )
                )
            VStack {
                TextEditor(text: $text)
                    .padding(.top, -5)
                    .font(
                        .system(
                            size: fontSize,
                            weight: .regular,
                            design: .monospaced
                        )
                    )
                    .foregroundStyle(.foreground.opacity(0.9))
                    .lineSpacing(3)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, horizontalPadding)
                    .onChange(of: text, {
                        withAnimation {
                            tooLong = currentMessageLength() > Int(messageLength)
                        }
                    })
                HStack {
                    if tooLong {
                        Button(
                            "Message longer than \(Int(messageLength)) characters",
                            systemImage: "questionmark.circle"
                        ) {
                            showLengthTip = true
                        }
                        .buttonStyle(.borderless)
                        .padding(.horizontal)
                        .popover(isPresented: $showLengthTip, arrowEdge: .leading) {
                            Text(
                                "Keeping your commit messages concise is recommended for readability.\n\nThe summary should usually be no greater than 50, and lines of the description no greater than 72 characters long as indicated by the margin on the right."
                            )
                            .frame(width: 480)
                            .padding()
                        }
                        .padding(.bottom)
                    }
                    Spacer()
                    HStack {
                        Button("Abort") {
                            text = ""
                            onCommit()
                        }
                        Button(
                            "Commit",
                            systemImage:
                                "point.topright.arrow.triangle.backward.to.point.bottomleft.scurvepath.fill",
                            action: onCommit
                        )
                        .keyboardShortcut("s")
                        .buttonStyle(.borderedProminent)
                        .labelStyle(.titleAndIcon)
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
                }
                .controlSize(.large)
            }
        }
        .containerBackground(.ultraThickMaterial, for: .window)
        .ignoresSafeArea(.all)
        .frame(minWidth: 440, minHeight: 80)
    }
}

#Preview {
    @Previewable @State var text = ""

    EditorView(text: $text, onCommit: {})
}
