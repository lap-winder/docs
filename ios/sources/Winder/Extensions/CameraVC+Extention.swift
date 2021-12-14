//
//  CameraVC+Extention.swift
//  Winder
//
//  Created by 이동규 on 2021/11/12.
//

import Foundation
import UIKit

extension CameraVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    // 카메라 세팅
    func openCamera() {
        self.imagePicker.sourceType = .camera   // 컨트롤러 기능 중 카메라 기능 사용
//        self.modalPresentationStyle = .fullScreen
        self.imagePicker.allowsEditing = false  // 편집 허용 x
        self.imagePicker.cameraDevice = .rear   // 후면 카메라
        self.imagePicker.cameraCaptureMode = .photo
        self.imagePicker.cameraFlashMode = .auto
//        self.imagePicker.showsCameraControls = true
        addOverlay()
        
        
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    
    func addOverlay() {
        let overlayView = UIView()
        overlayView.backgroundColor = .none
        overlayView.layer.borderWidth = 1
        overlayView.layer.borderColor = UIColor.black.cgColor
        self.imagePicker.view.subviews[0].alpha = 0.6
        
        //수정, (self.imagePicker.cameraOverlayView?.layer.position)!
//        let testxy = CGPoint(x: (self.imagePicker.view.layer.sublayers![0].frame.width / 3), y: 0)
        let origin = CGPoint(x: (self.imagePicker.view.layer.sublayers![0].frame.width / 6) * 2, y: 0)
        overlayView.frame = CGRect(origin: origin,
                                   size: CGSize(
                                    width: (self.imagePicker.view.layer.sublayers![0].frame.width / 6) * 2,
                                    height: (self.imagePicker.view.layer.sublayers![0].frame.height))
        )
//        overlayView.frame = self.imagePicker.view.layer.sublayers![0].frame
//        print((self.imagePicker.cameraOverlayView?.frame)!, (self.imagePicker.cameraOverlayView?.layer.position)!)
        print(self.imagePicker.view.layer.sublayers![0].frame.width / 3)
        self.imagePicker.cameraOverlayView = overlayView
        
//        for layer in self.imagePicker.view.layer.sublayers! {
//            print("pickers layer", layer)
//        }
//        print("pickers layer all: ", self.imagePicker.view.layer.sublayers!)
//        cameraView.tag = 101
        
    }
    
    // 카메라 찍고 나서 "Use Photo" 버튼 눌렀을 때 호출된다.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.CameraImageView.image = image
            self.caputredImage = image
            dismiss(animated: true, completion: nil)
        }
    }
}
