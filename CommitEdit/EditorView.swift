//
//  EditorView.swift
//  CommitEdit
//
//  Created by kramo on 07-11-2024.
//


import SwiftUI

import HighlightedTextEditor

struct EditorView: View {
    @Binding var text: String
    let onCommit: () -> Void
    let onAbort: () -> Void

    @State private var tooLong: Bool = false
    @State private var showLengthTip: Bool = false

    private let messageLength = 50.0
    private let descLength = 72.0
    private let horizontalPadding = 20.0

    static private let scissors = "# ------------------------ >8 ------------------------"
    static private let font = NSFont.monospacedSystemFont(
        ofSize: NSFont.systemFontSize + 1,
        weight: .regular
    )

    static private let dimRed    = NSColor.systemRed.withAlphaComponent(0.1)
    static private let dimGreen  = NSColor.systemGreen.withAlphaComponent(0.1)
    static private let dimBlue   = NSColor.systemBlue.withAlphaComponent(0.1)
    static private let dimYellow = NSColor.systemYellow.withAlphaComponent(0.1)

    static private func tintedRule (pattern: String, color: NSColor) -> HighlightRule {
        return HighlightRule(
            pattern: try! NSRegularExpression(
                pattern: pattern,
                options: [.anchorsMatchLines]
            ),
            formattingRules: [
                TextFormattingRule(key: .backgroundColor, value: color)
            ])
    }

    private let rules: [HighlightRule] = [
            HighlightRule(
                pattern: try! NSRegularExpression(pattern: #".*"#),
                formattingRules: [
                    TextFormattingRule(key: .font, value: font),
            ]),
            HighlightRule(
                pattern: try! NSRegularExpression(
                    pattern: #"^#.*"#,
                    options: [.anchorsMatchLines]
                ),
                formattingRules: [
                    TextFormattingRule(
                        key: .foregroundColor,
                        value: NSColor.secondaryLabelColor),
                ]
            ),
            HighlightRule(
                pattern: try! NSRegularExpression(
                    pattern: #"^@@.*@@"#,
                    options: [.anchorsMatchLines]
                ),
                formattingRules: [
                    TextFormattingRule(fontTraits: [.italic]),
                    TextFormattingRule(
                        key: .foregroundColor,
                        value: NSColor.systemBlue
                    )
            ]),
            tintedRule(pattern: #"^#\tnew file: .*"#,   color: dimGreen),
            tintedRule(pattern: #"^#\tmodified: .*"#,   color: dimYellow),
            tintedRule(pattern: #"^#\trenamed: .*"#,    color: dimYellow),
            tintedRule(pattern: #"^#\ttypechange: .*"#, color: dimYellow),
            tintedRule(pattern: #"^#\tcopied: .*"#,     color: dimBlue),
            tintedRule(pattern: #"^#\tdeleted: .*"#,    color: dimRed),
            tintedRule(pattern: #"^\+(.*)"#,            color: dimGreen),
            tintedRule(pattern: #"^\-(.*)"#,            color: dimRed),
            tintedRule(pattern: #"^#\tmodified: .*"#,   color: dimYellow),
        ]

    private func currentMessageLength() -> Int {
        if let message = text.split(separator: "\n")
            .prefix(while: { $0.trimmingCharacters(in: .whitespaces) != EditorView.scissors })
            .first(where: {!$0.trimmingCharacters(in: .whitespaces).hasPrefix("#")}) {
            return message.count
        } else { return 0 }
    }

    var body: some View {
        ZStack {
            Color.primary.opacity(0.08)
                .offset(
                    CGSize(
                        width: (" ".size(
                            withAttributes: [.font: EditorView.font]
                        ).width * (descLength + 0.5)) + horizontalPadding,
                        height: 0
                    )
                )
            VStack {
                HighlightedTextEditor(text: $text, highlightRules: rules)
                    .introspect { editor in
                        DispatchQueue.main.async {
                            editor.textView.drawsBackground = false
                            editor.textView.enclosingScrollView?.drawsBackground = false
                        }
                    }
                    .padding(.top, -5)
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
                        Button("Abort", action: onAbort)
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

    EditorView(text: $text, onCommit: {}, onAbort: {})
}
