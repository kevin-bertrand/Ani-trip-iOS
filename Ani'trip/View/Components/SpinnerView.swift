//
//  SpinnerView.swift
//  Ani'trip
//
//  Created by Kevin Bertrand on 04/07/2022.
//

import SwiftUI

struct SpinnerView: View {
    let rotationTime: Double = 0.75
    let animationTime: Double = 1.9
    let fullRotation: Angle = .degrees(360)
    static let initialDegree: Angle = .degrees(270)
    
    @State var spinnerStart: CGFloat = 0.0
    @State var spinnerEndS1: CGFloat = 0.03
    @State var spinnerEndS2S3: CGFloat = 0.03
    
    @State var rotationDegreeS1 = initialDegree
    @State var rotationDegreeS2 = initialDegree
    @State var rotationDegreeS3 = initialDegree
    @State var rotationDegreeS4 = initialDegree
    
    var body: some View {
        ZStack {
            // S4
            SpinnerCircleView(start: spinnerStart, end: spinnerEndS2S3, rotation: rotationDegreeS4, color: .yellow)
            
            // S3
            SpinnerCircleView(start: spinnerStart, end: spinnerEndS2S3, rotation: rotationDegreeS3, color: .blue)
            
            // S2
            SpinnerCircleView(start: spinnerStart, end: spinnerEndS2S3, rotation: rotationDegreeS2, color: .red)
            
            // S1
            SpinnerCircleView(start: spinnerStart, end: spinnerEndS1, rotation: rotationDegreeS1, color: .accentColor)
            
        }.frame(width: 200, height: 200)
            .onAppear() {
                self.animateSpinner()
                Timer.scheduledTimer(withTimeInterval: animationTime, repeats: true) { (mainTimer) in
                    self.animateSpinner()
                }
            }
    }
    
    // MARK: Animation methods
    func animateSpinner(with duration: Double, completion: @escaping (() -> Void)) {
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            withAnimation(Animation.easeInOut(duration: self.rotationTime)) {
                completion()
            }
        }
    }
    
    func animateSpinner() {
        animateSpinner(with: rotationTime) { self.spinnerEndS1 = 1.0 }
        
        animateSpinner(with: (rotationTime * 2) - 0.025) {
            self.rotationDegreeS1 += fullRotation
            self.spinnerEndS2S3 = 0.8
        }
        
        animateSpinner(with: (rotationTime * 2)) {
            self.spinnerEndS1 = 0.03
            self.spinnerEndS2S3 = 0.03
        }
        
        animateSpinner(with: (rotationTime * 2) + 0.0525) { self.rotationDegreeS2 += fullRotation }
        
        animateSpinner(with: (rotationTime * 2) + 0.225) { self.rotationDegreeS3 += fullRotation }
        
        animateSpinner(with: (rotationTime * 2) + 0.375) { self.rotationDegreeS4 += fullRotation }
    }
}

struct SpinnerCircleView: View {
    var start: CGFloat
    var end: CGFloat
    var rotation: Angle
    var color: Color
    
    var body: some View {
        Circle()
            .trim(from: start, to: end)
            .stroke(style: .init(lineWidth: 20, lineCap: .round))
            .fill(color)
            .rotationEffect(rotation)
    }
}

struct SpinnerView_Previews: PreviewProvider {
    static var previews: some View {
        SpinnerView()
    }
}
