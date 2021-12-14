//
//  RecomendedContentsView.swift
//  Winder
//
//  Created by 이동규 on 2021/11/12.
//

import Foundation
import UIKit

class RecomendedContentsView: UIView {
    
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var contentsImageView: UIImageView!
    @IBOutlet weak var contentsPageCtrl: UIPageControl!
    
    private var contentsPaths = [[String: Any?]]()
    var imageList = [UIImage]()
    
    func setUpAndAddGestureToEachView(completion: @escaping (UIImageView) -> ()) {
        // 각 이미지뷰 컨텐츠 저장
        HomepageAPIManager().requestContentsInfo(HomeContentInfo(label: .recommend, page: 3)) { nsdictArr, error in
            if let error = error {
                print(#function, error.localizedDescription)
            } else if let nsdictArr = nsdictArr {
                for item in nsdictArr {
                    print(#function, item)
                    self.parseReturnedData(item)
                }
                self.setUpContentsView()
                //completion 수정
                completion(self.contentsImageView)
            }
        }
        
    }
    
    private func parseReturnedData(_ item: NSDictionary) {
        self.contentsPaths.append([
            "content": item["content"],
            "create_at": item["create_at"],
            "id": item["id"],
            "owner": item["owner"],
            "thumbnail_url": item["thumbnail_url"],
            "title": item["title"],
            "view_count": item["view_count"]
        ])
    }
    
    func setUpContentsView() {
        //페이지 컨트롤 세팅
        self.contentsPageCtrl.numberOfPages = self.contentsPaths.count
        self.contentsPageCtrl.currentPage = 0
        self.contentsPageCtrl.pageIndicatorTintColor = .lightGray
        self.contentsPageCtrl.currentPageIndicatorTintColor = .black
        
        // 이미지뷰 기본세팅
        self.contentsImageView.contentMode = .scaleAspectFill
        self.contentsImageView.layer.cornerRadius = 25
        self.contentsImageView.clipsToBounds = true
        self.contentsImageView.isUserInteractionEnabled = true
        self.addGestureContents(self.contentsImageView)
        
        // 이미지뷰 이미지 로딩
        for i in 0..<self.contentsPaths.count {
            let urlStr = self.contentsPaths[i]["thumbnail_url"] as! String
            let url = URL(string: urlStr)
            //DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
            //DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    if let img = UIImage(data: data!) {
                        if let contentID = self.contentsPaths[i]["id"]! as? Int {
                            img.accessibilityValue = String(contentID)
                            print("HELLO \(img.accessibilityValue)")
                        }
                        self.imageList.append(img)
                    }
                    if i == 0 {
                        self.contentsImageView.image = self.imageList[i]
                    }
                }
            }
        }
    }
    
    func addGestureContents(_ uiView: UIImageView) {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeLeft.direction = .left
        uiView.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeRight.direction = .right
        uiView.addGestureRecognizer(swipeRight)
        //페이지 넘어가는것도 추가
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        // 만일 제스쳐가 있다면
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            // 발생한 이벤트가 각 방향의 스와이프 이벤트라면 해당 이미지 뷰를 빨간색 화살표 이미지로 변경
            var pagePostion = self.contentsPageCtrl.currentPage
            switch swipeGesture.direction {
                case UISwipeGestureRecognizer.Direction.left :
                if pagePostion ==  self.contentsPaths.count - 1 {
                    pagePostion = 0
                } else {
                    pagePostion += 1
                }
                case UISwipeGestureRecognizer.Direction.right :
                if pagePostion == 0 {
                    pagePostion = self.contentsPaths.count - 1
                } else {
                    pagePostion -= 1
                }
                default:
                    break
            }
            self.contentsPageCtrl.currentPage = pagePostion
            self.contentsImageView.image = self.imageList[self.contentsPageCtrl.currentPage]
        }
    }
    
    
    
    //+
}
