//
//  UIColor+Extension.swift
//  Winder
//
//  Created by 이동규 on 2021/11/16.
//
//rgb(250, 162, 214)
import Foundation
import UIKit

enum WinderColor {
    case pink
    case violet
    case lightpink
    case darknavy
}

extension UIColor {
    
  static func getWinderColor(_ name: WinderColor) -> UIColor {
    switch name {
    case .pink:
        return UIColor(displayP3Red: 255/255, green: 163/255, blue: 210/255, alpha: 1.0)
    case .violet:
        return UIColor(displayP3Red: 118/255, green: 57/255, blue: 245/255, alpha: 1.0)
    case .lightpink:
        return UIColor(displayP3Red: 254/255, green: 173/255, blue: 224/255, alpha: 1.0)
    case .darknavy:
        return UIColor(displayP3Red: 1/255, green: 4/255, blue: 48/255, alpha: 1.0)
    }
  }
    
    //+
}
