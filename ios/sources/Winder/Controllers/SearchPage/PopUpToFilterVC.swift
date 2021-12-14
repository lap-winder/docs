//
//  PopUpToFilterVC.swift
//  Winder
//
//  Created by 이동규 on 2021/11/17.
//

import Foundation
import UIKit

class PopUpToFilterVC: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var dismissBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPopUpView()
    }
    
    private func setUpPopUpView() {
        //self.popupView.alpha = 5.0
        self.backgroundView.backgroundColor = .systemGray.withAlphaComponent(0.5)
        self.popupView.layer.cornerRadius = 20
        self.dismissBtn.setTitle("", for: .normal)
        self.dismissBtn.tintColor = UIColor.getWinderColor(.violet)
    }

    @IBAction func didTapDismissBtn(sender: UIButton) {
        guard let preVC = self.presentingViewController as? MainTBC else { return }
        //print(prevc.viewControllers?[0].children[0])
        guard let winelistVC = preVC.viewControllers?[1].children[0] as? SearchListTVC else { return }
        winelistVC.viewWillAppear(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    //+
}
