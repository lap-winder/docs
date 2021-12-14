//
//  InfoContentsView.swift
//  Winder
//
//  Created by 이동규 on 2021/11/12.
//

import Foundation
import UIKit

class InfoContentsView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    private var contentsPaths = [[String: Any?]]()
    var imageViewList = [UIImageView]()
    
    func setUpStackView(completion: @escaping (UIImageView) -> ()) {
        self.stackView.spacing = 10
        
        HomepageAPIManager().requestContentsInfo(HomeContentInfo(label: .food, page: 2)) { nsdictArr, error in
            if let error = error {
                print(#function, error.localizedDescription)
            } else if let nsdictArr = nsdictArr {
                for item in nsdictArr {
                    print("hellow! \(item)")
                    self.parseReturnedData(item)
                }
                self.setUpViews(completion)
            }
        }
    }
    
    private func setUpViews(_ completion: (UIImageView) -> ()) {
        for i in 0..<self.contentsPaths.count {
            let uiImageview = UIImageView()
            let urlStr = self.contentsPaths[i]["thumbnail_url"] as! String
            let url = URL(string: urlStr)
            //DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
            //DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    uiImageview.image = UIImage(data: data!)
                }
            }
            uiImageview.layer.cornerRadius = 25
            uiImageview.clipsToBounds = true
            uiImageview.isUserInteractionEnabled = true
            uiImageview.widthAnchor.constraint(equalToConstant: self.stackView.frame.height).isActive = true
            self.stackView.addArrangedSubview(uiImageview)
            
            if let contentID = self.contentsPaths[i]["id"]! as? Int {
                uiImageview.accessibilityValue = String(contentID)
            }
            
            self.imageViewList.append(uiImageview)
            completion((self.imageViewList[i]))
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
}
