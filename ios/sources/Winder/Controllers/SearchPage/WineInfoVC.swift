//
//  WineInfoVC.swift
//  Winder
//
//  Created by 이동규 on 2021/11/17.
//

import Foundation
import UIKit

class WineInfoVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var wineInfoStackView: UIStackView!
    
    // UIView 요소들 인터페이스 프로퍼티(나중에 스택뷰에 넣기)
    @IBOutlet weak var wineInfoTitleImageView: WineInfoTitleImageView!
    @IBOutlet weak var wineInfoSecondView: WineInfoSecondView!
    @IBOutlet weak var wineInfoNameView: WineInfoNameView!
    @IBOutlet weak var wineInfoManufactureView: WineInfoManufactureView!
    @IBOutlet weak var wineInfoRatingPriceView: WineInfoRatingPriceView!
    @IBOutlet weak var wineInfoDescriptionView: WineInfoDescriptionView!
    // grape, tastenote, winestyleDesc 추가 연결
    @IBOutlet weak var wineInfoGrapeView: WineInfoGrapeView!
    @IBOutlet weak var wineInfoTasteNoteView: WineInfoTasteNoteView!
    @IBOutlet weak var wineInfoStyleDescView: WineInfoStyleDescView!
    
    
    @IBOutlet weak var dismisBtn: UIButton!
    @IBOutlet weak var likeWineBtn: UIButton!
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    var wineDetail: WineDetail?  {
        didSet {
            DispatchQueue.main.async {
                self.updateControls(for: self.wineDetail)
            }
        }
    }
    
    var paramWineID: Int64?
    
    var isStatusBarStyleDefault: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        self.navBarHidden()
        self.setUpBtnStyle()
        self.setUpStatusBarStyle(color: UIColor.getWinderColor(.lightpink), statusBarStyle: false)
        self.setUpLayoutStyle()
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
    
    //MARK: 와인데이터 정보 세팅
    func updateControls(for wineDetail: WineDetail?) {
        self.getImageFromURL((wineDetail?.images["wine_bottle"])!, completion: { image in
            if let image = image {
                self.wineInfoTitleImageView.wineTitleImageVIew.image = image
            }
        })
        self.getImageFromURL((wineDetail?.images["country_flag"])!) { image in
            if let image = image {
                self.wineInfoManufactureView.wineMadeByIcon.image = image
            }
        }
        self.wineInfoSecondView.wineryLabel.text = wineDetail?.winery.name
        self.wineInfoNameView.wineTitleNameLabel.text = wineDetail?.name
        self.wineInfoManufactureView.wineMadeByLabel.text = "\(wineDetail!.country.name), \(wineDetail!.region.name)"
        self.wineInfoRatingPriceView.ratingLabel.text = "\(wineDetail!.rating) ⭐️⭐️⭐️⭐️⭐️"
        self.wineInfoRatingPriceView.priceLabel.text = "\(wineDetail!.price) 🇰🇷"
        self.wineInfoDescriptionView.wineDescriptionLabel.text = self.wineDetail?.description
        //grape, tastenotes, winestyle 추가
        //self.wineInfoGrapeView.grapesLabel.text =
        self.wineInfoTasteNoteView.tasteNoteintensitySlider.isUserInteractionEnabled = false
        self.wineInfoTasteNoteView.tasteNoteintensitySlider.value = (wineDetail?.characters["intensity"] as! NSString).floatValue
        self.wineInfoTasteNoteView.tasteNoteTannicSlider.isUserInteractionEnabled = false
        self.wineInfoTasteNoteView.tasteNoteTannicSlider.value = (wineDetail?.characters["tannic"] as! NSString).floatValue
        self.wineInfoTasteNoteView.tasteNoteSweetnessSlider.isUserInteractionEnabled = false
        self.wineInfoTasteNoteView.tasteNoteSweetnessSlider.value = (wineDetail?.characters["sweetness"] as! NSString).floatValue
        self.wineInfoTasteNoteView.tasteNoteAciditySlider.isUserInteractionEnabled = false
        self.wineInfoTasteNoteView.tasteNoteAciditySlider.value = (wineDetail?.characters["acidity"] as! NSString).floatValue
        self.wineInfoStyleDescView.wineStyleDescriptionLabel.text = wineDetail?.wine_style.description
        
    }
    
    private func setUpLayoutStyle() {
        self.scrollView.backgroundColor = UIColor.getWinderColor(.lightpink)
        self.wineInfoTitleImageView.backgroundColor = UIColor.getWinderColor(.lightpink)
        self.wineInfoSecondView.layer.cornerRadius = 30
        self.wineInfoSecondView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
    }

    @objc func popViewControllerOnScreenEdgeSwipe(sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .recognized {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setUpStatusBarStyle(color: UIColor, statusBarStyle: Bool) {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            let statusBarHeight: CGFloat = (window?.windowScene?.statusBarManager?.statusBarFrame.height)!
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = color
            view.addSubview(statusbarView)
          
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = color
        }
        self.isStatusBarStyleDefault = statusBarStyle
        setNeedsStatusBarAppearanceUpdate() // 이걸해줘야 상태바 최신화됨...
    }
    
    private func setUpBtnStyle() {
        self.dismisBtn.setTitle("", for: .normal)
        self.likeWineBtn.setTitle("", for: .normal)
        self.bookmarkBtn.setTitle("", for: .normal)
        
        self.dismisBtn.layer.cornerRadius = self.dismisBtn.frame.height / 4
        self.likeWineBtn.layer.cornerRadius = self.likeWineBtn.frame.height / 4
        self.bookmarkBtn.layer.cornerRadius = self.bookmarkBtn.frame.height / 4
    }
    
    @IBAction func didTapCancelBtn(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapLikeBtn(_ sender: Any) {
        self.alert("서비스 준비중입니다.", completion: nil)
    }
    
    @IBAction func didTapBookmarkBtn(_ sender: Any) {
        self.alert("서비스 준비중입니다.", completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print(#function, self.wineDetail)
        self.navBarHidden()
    }
    
    func navBarHidden() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        //self.navigationItem.searchController?.searchBar.isHidden = true
        //self.navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.isStatusBarStyleDefault ? .darkContent : .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// MARK: - 스크롤뷰 델리게이트
extension WineInfoVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= self.wineInfoTitleImageView.frame.height + self.wineInfoSecondView.layer.cornerRadius {
            self.setUpStatusBarStyle(color: UIColor.white, statusBarStyle: true)
        } else {
            self.setUpStatusBarStyle(color: UIColor.getWinderColor(.lightpink), statusBarStyle: false)
        }
    }
    //+
}
