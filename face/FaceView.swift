//
//  FaceView.swift
//  face
//
//  Created by Wenzhong Zheng on 2017-08-15.
//  Copyright © 2017 Wenzhong. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    @IBInspectable
    var scale: CGFloat = 0.9 { didSet{ setNeedsDisplay() } }
    
    @IBInspectable
    var eyesOpen: Bool = false {
        didSet{
            leftEye.eyesOpen = eyesOpen
            rightEye.eyesOpen = eyesOpen
        }
    }
    
    @IBInspectable
    var mouthCurvature: Double = 1.0 { didSet{ setNeedsDisplay() } }// 1.0 is full smile and -1.0 is full frown
    
    @IBInspectable
    var lineWidth: CGFloat = 5.0 {
        didSet{
            leftEye.lineWidth = lineWidth
            rightEye.lineWidth = lineWidth
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var color: UIColor = .blue {
        didSet{
            leftEye.color = color
            rightEye.color = color
            setNeedsDisplay()
        }
    }
    
    @objc func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer) {
        switch pinchRecognizer.state {
        case .changed, .ended:
            scale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
    
    private var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    private var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private func pathForSkull() -> UIBezierPath {
        let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: false)
        
        path.lineWidth = lineWidth
        return path
    }
    
    private enum Eye {
        case left
        case right
    }
    
    private func centerOfEye(_ eye:Eye) -> CGPoint {
        let eyeOffset = skullRadius / Ratios.skullRaiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffset
        return eyeCenter
    }
    
    private lazy var leftEye = createEye()
    private lazy var rightEye = createEye()
    
    private func createEye() -> EyeView {
        let eye = EyeView()
        eye.isOpaque = false
        eye.color = color
        eye.lineWidth = lineWidth
        addSubview(eye)
        return eye
    }
    
    private func positionEye(_ eye: EyeView, center: CGPoint) {
        let size = skullRadius / Ratios.skullRaiusToEyeRadius * 2
        eye.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
        eye.center = center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        positionEye(leftEye, center: centerOfEye(.left))
        positionEye(rightEye, center: centerOfEye(.right))
    }
    
//    private func pathForEye(_ eye: Eye) -> UIBezierPath {
//
//        let eyeRadius = skullRadius / Ratios.skullRaiusToEyeRadius
//        let eyeCenter = centerOfEye(eye)
//        
//        let path: UIBezierPath
//        if eyesOpen {
//            path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
//        } else {
//            path = UIBezierPath()
//            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
//            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
//        }
//        
//        path.lineWidth = lineWidth
//        return path
//    }
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.skullRaiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.skullRaiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.skullRaiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth / 2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        let smileOffset = CGFloat(max(-1,min(mouthCurvature,1))) * mouthRect.height
        
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        
        let cp1 = CGPoint(x: start.x + mouthRect.width / 3, y: start.y + smileOffset)
        let cp2 = CGPoint(x: end.x - mouthRect.width / 3, y: start.y + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        pathForSkull().stroke()
//        pathForEye(.left).stroke()
//        pathForEye(.right).stroke()
        pathForMouth().stroke()
    }

    private struct Ratios {
        static let skullRaiusToEyeOffset: CGFloat = 3
        static let skullRaiusToEyeRadius: CGFloat = 10
        static let skullRaiusToMouthWidth: CGFloat = 1
        static let skullRaiusToMouthHeight: CGFloat = 3
        static let skullRaiusToMouthOffset: CGFloat = 3
    }
}
