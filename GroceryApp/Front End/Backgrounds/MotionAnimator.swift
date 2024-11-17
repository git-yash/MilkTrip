//
//  MotionAnimatorView.swift
//  GroceryApp
//
//  Created by Aiden Seibel on 11/17/24.
//

import SwiftUI

struct MotionAnimatorView: View {
    @State private var randomCircle = Int.random(in: 15...30)
    @State private var isAnimating: Bool = false
    //RANDOM COORDINATE
    func randomCoordinate(max:CGFloat) ->CGFloat {
        return CGFloat.random(in: 0...max)
    }
    //RANDOM SIZE
    func randomSize() ->CGFloat{
        return CGFloat(Int.random(in: 10...200))
    }
    
    //RANDOM SCALE
    func randomScale() ->CGFloat{
        return CGFloat(Double.random(in: 0.1...2.0))
    }
    //RANDOM SPEED
    func randomSpeed() ->Double{
        return Double.random(in: 1.5...3.0)
    }
    
    //RANDOM DELAY
    func randomDelay() ->Double{
        return Double.random(in: 0.2...1.0)
    }


    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0...randomCircle, id: \.self) { item in
                    Circle()
                        .foregroundColor(Color(hex: "#4a6375"))
                        .opacity(0.6)
                        .scaleEffect(isAnimating ? randomScale() : 1)
                        .frame(width: randomSize(), height: randomSize(), alignment: .center)
                        .position(
                            x: randomCoordinate(max: geometry.size.width),
                            y: randomCoordinate(max: geometry.size.height)
                        )
                        .withSpringAnimation(
                            stiffness: 0.25,
                            damping: 0.5,
                            isAnimating: isAnimating,
                            speed: randomSpeed(),
                            delay: randomDelay()
                        )
                }
            }
            .drawingGroup()
        }
        .onAppear {
            isAnimating = true
        }
    }
}
extension View {
    func withSpringAnimation(
        stiffness: Double,
        damping: Double,
        isAnimating: Bool,
        speed: Double,
        delay: Double
    ) -> some View {
        self.modifier(SpringAnimationModifier(
            stiffness: stiffness,
            damping: damping,
            isAnimating: isAnimating,
            speed: speed,
            delay: delay
        ))
    }
}

struct SpringAnimationModifier: ViewModifier {
    let stiffness: Double
    let damping: Double
    let isAnimating: Bool
    let speed: Double
    let delay: Double
    
    func body(content: Content) -> some View {
        content
            .animation(
                Animation.interpolatingSpring(
                    stiffness: stiffness,
                    damping: damping
                )
                .repeatForever()
                .speed(speed)
                .delay(delay),
                value: isAnimating
            )
    }
}
struct SharedViews {
    static let motionAnimator = MotionAnimatorView()
}
#Preview {
    MotionAnimatorView()
}
