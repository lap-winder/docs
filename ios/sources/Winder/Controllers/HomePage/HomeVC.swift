//
//  HomeVC.swift
//  Winder
//
//  Created by 이동규 on 2021/11/12.
//

import Foundation
import UIKit

class HomeVC: UIViewController {
    
    
    @IBOutlet weak var recomendedContentsView: RecomendedContentsView! {
        didSet {
            print(#function, "is called.")
            self.paramRecoContentAccessID =  recomendedContentsView.contentsImageView.image?.accessibilityValue
        }
    }
    
    @IBOutlet weak var newsContentsView: NewsContentsView!
    @IBOutlet weak var blogContentsView: BlogContentsView!
    @IBOutlet weak var infoStackView: InfoContentsView!
    
    var paramContentID: String = ""
    var paramContentURL: String?
    var paramRecoContentAccessID: String? {
        didSet {
            if let id = paramRecoContentAccessID {
                print("hereparam", id)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavBarItem()
        self.setUpAllViews()
        self.setupNavBarSettings()
    }
    
    private func setUpNavBarItem() {
        //
    }
    
    func setUpAllViews() {
        self.recomendedContentsView.setUpAndAddGestureToEachView { imageView in
            self.addGestureToUIPageView(imageView)
        }
        self.newsContentsView.setUpStackView { imageView in
            self.addGestureToUIView(imageView)
        }
        self.blogContentsView.setUpStackView { imageView in
            self.addGestureToUIView(imageView)
        }
        self.infoStackView.setUpStackView { imageView in
            self.addGestureToUIView(imageView)
        }
    }
    
    func setupNavBarSettings() {
        //self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.sizeToFit()
        
        // 이미지+라지타이틀
        navigationItem.largeTitleDisplayMode = .automatic
        let logoImageView = UIImageView.init(image: UIImage(named: "winder_homepage.png"))
        logoImageView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        logoImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = logoImageView
        navigationItem.titleView?.sizeToFit()
    }
    
    
    func addGestureToUIPageView(_ uiimgview: UIImageView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePageTap(sender:)))
        uiimgview.addGestureRecognizer(tapGesture)
    }
    
    @objc func handlePageTap(sender: UITapGestureRecognizer) {
        if let accessContentID = self.recomendedContentsView
            .imageList[self.recomendedContentsView.contentsPageCtrl.currentPage]
            .accessibilityValue {
            
            self.paramContentID = accessContentID
            HomepageAPIManager().requestContentsURL(self.paramContentID) { contentStr, error in
                if let error = error {
                    print(#function, error.localizedDescription)
                } else if let contentStr = contentStr {
                    self.paramContentURL = contentStr
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "ID-manual-HomeVC-HomeInfoVC", sender: self)
                }
            }
        }
    }
    
    
    func addGestureToUIView(_ uiimgview: UIImageView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        if let accessContentID = uiimgview.accessibilityValue {
            tapGesture.accessibilityValue = accessContentID
        }
        uiimgview.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if let accessContentID = sender.accessibilityValue {
            self.paramContentID = accessContentID
            HomepageAPIManager().requestContentsURL(self.paramContentID) { contentStr, error in
                if let error = error {
                    print(#function, error.localizedDescription)
                } else if let contentStr = contentStr {
                    self.paramContentURL = contentStr
                    print("hererer1231e", self.paramContentURL, contentStr)
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "ID-manual-HomeVC-HomeInfoVC", sender: self)
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ID-manual-HomeVC-HomeInfoVC" {
            if let infoVC = segue.destination as? HomeInfoVC {
                print("hererer1e", self.paramContentURL)
                if let url = self.paramContentURL {
                    print("hererere2", url)
                    infoVC.paramContentsURL = url
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.paramContentURL = nil
    }
    
    //+
}

