//
//  CameraVC.swift
//  Winder
//
//  Created by 이동규 on 2021/11/12.
//

import Foundation
import UIKit

class CameraVC: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var CameraImageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    var paramWineID: Int64?
    
    var caputredImage: UIImage?
    var wineDetail: WineDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.imagePicker.delegate = self
    }
    
    @IBAction func didTapCaptureBtn(_ sender: Any) {
        // 델리게이트에 정의해놓은 함수 실행
        self.openCamera()
    }
    
    var preventMultiTouchBtn = false
    @IBAction func didTapPushBtn(_ sender: Any) {
        if self.preventMultiTouchBtn == true {
            return
        }
        self.preventMultiTouchBtn = true
        self.spinner.startAnimating()
        if let caputredImage = self.caputredImage {
            WineModel().loadDetailFromAPIByImage(CapturedImageModel(capturedImage: caputredImage, paramName: "fieldname", fileName: "user_input.png")) { wineDetail, error in
                if let error = error {
                    print(#function, error.localizedDescription)
                    DispatchQueue.main.async {
                        self.spinner.stopAnimating()
                        self.alert("분석 중 오류가 생겼습니다.", completion: nil)
                    }
                }
                if let wineDetail = wineDetail {
                    self.wineDetail = wineDetail
                    print(#function, self.wineDetail)
                    DispatchQueue.main.async {
                        self.spinner.stopAnimating()
                        self.spinner.hidesWhenStopped = true
                        guard let popupResultVC = self.storyboard?.instantiateViewController(withIdentifier: "ID-PopUpToShowResultVC") as? PopUpToShowResultVC else { return }
                        self.getImageFromURL((wineDetail.images["wine_bottle"])!, completion: { image in
                            if let image = image {
                                popupResultVC.paramWineImage = image
                                popupResultVC.paramWineryAndTitleLabel = "\(wineDetail.winery.name), \(wineDetail.name)"
                                popupResultVC.modalPresentationStyle = .overFullScreen
                                self.present(popupResultVC, animated: true, completion: nil)
                            } else {
                                self.spinner.stopAnimating()
                                self.alert("사진 로드 중 오류가 생겼습니다.", completion: nil)
                            }
                        })
                    }
                } else {
                    self.spinner.stopAnimating()
                    self.alert("분석 중 오류가 생겼습니다.", completion: nil)
                }
            }
        } else {
            self.spinner.stopAnimating()
            self.alert("사진을 촬영 해주세요.", completion: nil)
        }
        self.preventMultiTouchBtn = false
    }
    
    func getImageFromURL(_ urlStr: String, completion: @escaping (UIImage?) -> ()) {
        let url = URL(string: urlStr)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    completion(image)
                } else {
                    print(#function, "parse error")
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.CameraImageView.image = UIImage(named: "capture_guideline.png")
        self.caputredImage = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ID-manual-CameraVC-WineInfoVC" {
            guard let infoVC = segue.destination as? WineInfoVC else { return }
            infoVC.wineDetail = self.wineDetail
        }
    }
    
    //+
}
