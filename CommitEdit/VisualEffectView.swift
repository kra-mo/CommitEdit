//
//  VisualEffectView.swift
//  CommitEdit
//
//  Created by kramo on 07-11-2024.
//

import SwiftUI

struct VisualEffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material = .underWindowBackground

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.state = .active

        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) { }
}
