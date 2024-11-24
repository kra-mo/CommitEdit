//
//  WelcomeView.swift
//  CommitEdit
//
//  Created by kramo on 07-11-2024.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(\.openURL) private var openURL

    @State private var closeButtonOpacity = 0.5
    @State private var donateAlertPresented = false

    let gitCommand = "git config --global core.editor \"open -W -a 'CommitEdit'\""

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    if let appIcon = NSImage(named: NSImage.applicationIconName) {
                        Image(nsImage: appIcon)
                            .resizable()
                            .frame(width: 150, height: 150)
                            .shadow(color: Color.blue.opacity(0.5), radius: 60)
                    }
                    Text("CommitEdit").font(.largeTitle)
                        .fontWeight(.bold).padding()
                    Text("Run the following in the Terminal:")
                        .font(.title2)
                    Text(gitCommand)
                        .font(.system(.headline, design: .monospaced))
                        .padding(5)
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(Color.white)
                        .cornerRadius(5)
                    Button(
                        "Copy Command",
                        systemImage: "document.on.document"
                    ) {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(gitCommand, forType: .string)
                    }
                    .controlSize(.large)
                    .padding()
                    Text("After that, commit messages should open for editing here.")
                        .padding()
                }.padding()
            }
            .defaultScrollAnchor(.center)
            .toolbar {
                ToolbarItem {
                    Spacer()
                }
                ToolbarItem {
                    Button("Donate", systemImage: "heart.fill")
                    {
                        donateAlertPresented = true
                    }
                    .labelStyle(.titleAndIcon)
                }
            }
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
        .containerBackground(.ultraThickMaterial, for: .window)
        .ignoresSafeArea()
        .frame(minWidth: 540, minHeight: 440)
        .alert(isPresented: $donateAlertPresented) {
            Alert(
                title: Text("Support CommitEdit"),
                message: Text("CommitEdit is a free and open source app that relies on donations. Please consider chipping in!"),
                primaryButton: .default(
                    Text("View Options"),
                    action: {
                        openURL(URL(
                            string: "https://github.com/kra-mo/CommitEdit#donations"
                        )!)
                    }
                ),
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    WelcomeView()
}
