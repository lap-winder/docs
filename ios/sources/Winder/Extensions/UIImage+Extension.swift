//
//  UIImage+Extension.swift
//  Winder
//
//  Created by 이동규 on 2021/12/02.
//

import Foundation
import UIKit

extension UIImage {
    func rotateImage()-> UIImage?  {
        if (self.imageOrientation == UIImage.Orientation.up ) {
            return self
        }
        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
       let copy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return copy
    }
}
