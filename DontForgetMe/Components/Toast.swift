//
//  Toast.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 4/23/22.
//

import SwiftUI

struct Toast: ViewModifier {
    static let duration: TimeInterval = 3
    let message: String
    @Binding var isShowing: Bool
    
    func body(content: Content) -> some View {
        ZStack {
          content
          toastView
        }
    }
    
    private var toastView: some View {
        VStack {
          Spacer()
          if isShowing {
            Group {
                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(8)
            }
                .background(.black.opacity(0.588))
                .cornerRadius(8)
                .onTapGesture {
                    isShowing = false
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Toast.duration) {
                        isShowing = false
                    }
                }
          }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 18)
        .animation(.linear(duration: 0.3), value: isShowing)
        .transition(.opacity)
    }
}

extension View {
    func toast(message: String, isShowing: Binding<Bool>) -> some View {
        self.modifier(Toast(message: message, isShowing: isShowing))
    }
}
