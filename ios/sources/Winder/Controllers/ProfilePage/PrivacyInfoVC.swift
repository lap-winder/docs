//
//  PrivacyInfoVC.swift
//  Winder
//
//  Created by 이동규 on 2021/11/30.
//

import Foundation
import WebKit
import UIKit


class PrivacyInfoVC: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var wkView: WKWebView! {
        didSet {
            self.wkView.navigationDelegate = self
            self.wkView.uiDelegate = self
        }
    }
    
    var paramContentsURL: String?
    
    @IBAction func didTapDismissTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpWebView()
    }
    
    private func setUpWebView() {
        var str: String = ""
        if let urlStr = self.paramContentsURL {
            str = urlStr
        }
        let url = URL(string: str)
        let request = URLRequest(url: url!)
        self.wkView.load(request)
    }
    
    //+
}

// MARK: - 웹뷰 델리게이트
extension PrivacyInfoVC: WKNavigationDelegate {
    // 웹뷰가 컨텐츠 읽기 시작할 때
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.spinner.startAnimating()
    }
    
    // 로딩 끝
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.spinner.stopAnimating()
    }
    
    // 로딩 실패
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.spinner.stopAnimating()
        // 이전화면으로 되돌리기 까지 해버리기~
        self.alert("정보 페이지를 읽어오지 못했습니다.") {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    // url,네트워크 오류
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.spinner.stopAnimating()
        // 이전화면으로 되돌리기 까지 해버리기~
        self.alert("정보 페이지를 읽어오지 못했습니다.") {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

extension PrivacyInfoVC: WKUIDelegate {
    
}
