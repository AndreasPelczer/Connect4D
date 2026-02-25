//
//  DropAnimationModifier.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//


import SwiftUI

struct DropAnimationModifier: ViewModifier {
    let shouldAnimate: Bool
    let rowsToFall: Int
    
    @State private var dropped = false
    
    func body(content: Content) -> some View {
        content
            .offset(y: shouldAnimate && !dropped ? -CGFloat(rowsToFall) * 60 : 0)
            .animation(
                shouldAnimate ? .easeIn(duration: 0.25) : nil,
                value: dropped
            )
            .onChange(of: shouldAnimate) { _, newValue in
                if newValue {
                    dropped = false
                    DispatchQueue.main.async {
                        dropped = true
                    }
                }
            }
    }
}