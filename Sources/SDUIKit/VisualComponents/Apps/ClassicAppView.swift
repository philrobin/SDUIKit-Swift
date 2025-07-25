//
//  AppView.swift
//  SDUIiOS
//
//  Created by Philippe Robin on 28/05/2025.
//

import SwiftUI

struct ClassicAppView: View {
    
    let app: App
    
    @Environment(\.colorScheme) private var colorScheme
    
    init(app: App) {
        self.app = app
    }
    
    var body: some View {
        let accent = app.stylesheet.colors["accent"]
        VisualComponentView(app.rootStack)
            .if(accent != nil) {
                $0.accentColor(Color(hex: accent!, darkMode: colorScheme == .dark))
            }
    }
}
