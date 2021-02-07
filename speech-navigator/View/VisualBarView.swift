//
//  VisualBarView.swift
//  speech-navigator
//
//  Created by YINSHENG DONG on 2021-02-06.
//

import SwiftUI

struct VisualBarView: View {
    var value: CGFloat
    var numberOfSamples: Int = 30
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom))
                .frame(width: UIScreen.main.bounds.width - CGFloat(numberOfSamples) * 10 / CGFloat(numberOfSamples), height: value)
        }
    }
}
