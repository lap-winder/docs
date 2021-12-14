//
//  VC+Extentsion.swift
//  Winder
//
//  Created by 이동규 on 2021/11/15.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alert(_ message: String, completion: (() -> Void)? = nil) {
        //혹시라도 메소드가 서브쓰레드에서 호출되도 메인쓰레드에서 실행되도록
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil,
                                          message: message,
                                          preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "확인", style: .cancel) { (_) in
                completion?()   // completion이 nil 이 아닐 때만 실행
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //
}
