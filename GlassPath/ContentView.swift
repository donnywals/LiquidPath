//
//  ContentView.swift
//  GlassPath
//
//  Created by Donny Wals on 01/07/2025.
//

import SwiftUI

enum ButtonType: String {
    case home, write, chat, email
    
    var systemImage: String {
        switch self {
        case .home:
            return "house"
        case .write:
            return "pencil"
        case .chat:
            return "bubble"
        case .email:
            return "at"
        }
    }
    
    var label: String {
        self.rawValue.capitalized
    }
    
    var duration: CGFloat {
        switch self {
        case .home:
            return 0.3
        case .write:
            return 0.4
        case .chat:
            return 0.5
        case .email:
            return 0.6
        }
    }
    
    func offset(expanded: Bool) -> CGSize {
        guard expanded else {
            return .zero
        }
        
        switch self {
        case .home:
            return offset(atIndex: 0, expanded: expanded)
        case .write:
            return offset(atIndex: 1, expanded: expanded)
        case .chat:
            return offset(atIndex: 2, expanded: expanded)
        case .email:
            return offset(atIndex: 3, expanded: expanded)
        }
    }
    
    private func offset(atIndex index: Int, expanded: Bool) -> CGSize {
        let radius: CGFloat = 120
        let startAngleDeg = -180.0
        let step = 90.0 / Double(4 - 1)
        
        let angleDeg = startAngleDeg + (Double(index) * step)
        let angleRad = angleDeg * .pi / 180
        
        let x = cos(angleRad) * radius
        let y = sin(angleRad) * radius
        
        return CGSize(width: x, height: y)
    }
}

struct ContentView: View {
    @State private var isExpanded = false
    @Namespace var glassNamespace
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color
                .clear
                .overlay(
                    Image("bg_img")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                )
            
            GlassEffectContainer {
                ZStack {
                    button(type: .home)
                    button(type: .write)
                    button(type: .chat)
                    button(type: .email)
                    
                    Button {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    } label: {
                        Label("Home", systemImage: "list.bullet")
                            .labelStyle(.iconOnly)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                    }
                    .glassEffect(.regular.tint(.purple.opacity(0.8)).interactive())
                    .glassEffectID("menu", in: glassNamespace)
                }
            }.padding(32)
        }
    }
    
    private func button(type: ButtonType) -> some View {
        return Button {} label: {
            Label(type.label, systemImage: type.systemImage)
                .labelStyle(.iconOnly)
                .frame(width: 50, height:50)
                .opacity(isExpanded ? 1 : 0)
        }
        .glassEffect(.regular.tint(.white.opacity(0.8)).interactive())
        .glassEffectID(type.label, in: glassNamespace)
        .offset(type.offset(expanded: isExpanded))
        .animation(.spring(duration: type.duration * 3, bounce: 0.2), value: isExpanded)
    }
}

#Preview {
    ContentView()
}
