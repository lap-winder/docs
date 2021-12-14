//
//  MainTBC.swift
//  Winder
//
//  Created by 이동규 on 2021/11/12.
//

import Foundation
import UIKit

@IBDesignable class TabBarWithCorners: UITabBar {
    
    @IBInspectable var color: UIColor?
    @IBInspectable var radii: CGFloat = 18.0    //18.0

    private var shapeLayer: CALayer?

    override func draw(_ rect: CGRect) {
        addShape()
        setTabbarItemColor()
    }
    
    private func setTabbarItemColor() {
        self.tintColor = UIColor(displayP3Red: 126/255, green: 54/255, blue: 254/255, alpha: 1.0)
    }

    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.gray.withAlphaComponent(0.1).cgColor
        shapeLayer.fillColor = color?.cgColor ?? UIColor.white.cgColor
        shapeLayer.lineWidth = 0.5
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0, height: -3)
        shapeLayer.shadowOpacity = 0.1
        shapeLayer.shadowPath =  UIBezierPath(roundedRect: bounds, cornerRadius: radii).cgPath
        if let oldShapeLayer = self.shapeLayer {
            layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }

    private func createPath() -> CGPath {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radii, height: 0.0))
        return path.cgPath
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.isTranslucent = true
        var tabFrame = self.frame
        tabFrame.size.height = 65 + (UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? CGFloat.zero)
        tabFrame.origin.y = self.frame.origin.y + ( self.frame.height - 65 - (UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? CGFloat.zero))
        self.layer.cornerRadius = 20
        self.frame = tabFrame
        self.items?.forEach({ $0.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -1.0) })
    }
}

class MainTBC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
