//
//  LogInVC.swift
//  Winder
//
//  Created by 이동규 on 2021/11/15.
//

import Foundation
import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
import NaverThirdPartyLogin

class LogInVC: UIViewController {
    
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var CancelBtn: UIImageView! {
        didSet {
            CancelBtn.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self,action: #selector(justDismissTap(sender:)))
            self.CancelBtn.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet weak var kakaoLoginBtn: UIImageView! {
        didSet {
            kakaoLoginBtn.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapKakaoLoginBtn(sender:)))
            self.kakaoLoginBtn.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet weak var naverLoginBtn: UIImageView! {
        didSet {
            naverLoginBtn.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapNaverLoginBtn(sender:)))
            self.naverLoginBtn.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField! { didSet { emailTextField.delegate = self } }
    @IBOutlet weak var passwordTextField: UITextField!  { didSet { passwordTextField.delegate = self } }
    
    //네이버 로그인 URL 정리
    let naverLoginURL: Dictionary<String, String> = [
        "authorize": "https://nid.naver.com/oauth2.0/authorize",
        "tokenhandler": "https://nid.naver.com/oauth2.0/token",
        "accessprofile": "https://openapi.naver.com/v1/nid/me"
    ]
    //네이버 로그인 인스턴스 생성
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    
    // MARK: -- 멤버함수 시작
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        self.naverLoginInstance?.delegate = self
    }
    
    private func setUpViews() {
        self.logoImgView.image = UIImage(named: "winder_1.png")
    }
    
    @objc
    func justDismissTap(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: 네이버 로그인
    @objc
    func didTapNaverLoginBtn(sender: UITapGestureRecognizer) {
        print("\(#function)")
        //로직 좀 수정해야할듯
//        if let _ = SecurityUtils().load(SecurityUtils().bundleName, account: "accessToken"),
//            let _ = SecurityUtils().load(SecurityUtils().bundleName, account: "refreshToken") {
//            self.naverLoginInstance?.requestDeleteToken()
//        }
        self.naverLoginInstance?.requestThirdPartyLogin()
        
    }
    
    // MARK: 카카오 로그인
    @objc
    func didTapKakaoLoginBtn(sender: UITapGestureRecognizer) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoAccount(prompts: []) { oauthToken, error in
                if let error = error {
                    print(#function, error.localizedDescription)
                } else if let oauthToken = oauthToken {
                    print("otoken: \(oauthToken)")
                    let tokenInfo = TokenInfo(accessToken: self.setKakaoTokenInfo(oauthToken, option: .access),
                                              refreshToken: self.setKakaoTokenInfo(oauthToken, option: .refresh),
                                              provider: "kakao"
                    )
                    //서버에 푸쉬하고 토큰 키체인 및 유저정보 유저디폴트에 저장
                    MemberServiceAPIManager().pushTokenFromKakaoLogin(tokenInfo) { email, nickname, provider, error in
                        if let error = error {
                            self.alert(error.localizedDescription, completion: nil)
                        } else if let email = email, let nickname = nickname, let provider = provider {
                            //1. 리프레시,액세스토큰 키체인에 저장
                            SecurityUtils().save(SecurityUtils().bundleName, account: "accessToken", value: oauthToken.accessToken)
                            SecurityUtils().save(SecurityUtils().bundleName, account: "refreshToken", value: oauthToken.refreshToken)

                            //2. 유저디폴트에 저장
                            MemberInfoManager().deviceLogin(userInfoKey: UserInfoKey(loginEmail: email, loginNickname: nickname, provider: provider))
                            
                            //3. 프로필 화면으로 복귀
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                    //self.checkUserInfoFromKakaoAPI()
                }
            }
        }
    }
    
    // MARK: 카카오 로그인시 리턴된 토큰 서버에 보낼 형식 지정
    func setKakaoTokenInfo(_ oauthToken: OAuthToken, option: TokenType) -> TokenAndExpiredDict {
        var tokenDict: TokenAndExpiredDict
        if option == .access {
            tokenDict = [
                "token": "\(oauthToken.accessToken)",
                "expireAt": "\(oauthToken.expiredAt)",
                "expireIn": "\(oauthToken.expiresIn)",
            ]
        } else {
            tokenDict = [
                "token": "\(oauthToken.refreshToken)",
                "expireAt": "\(oauthToken.refreshTokenExpiredAt)",
                "expireIn": "\(oauthToken.refreshTokenExpiresIn)",
            ]
        }
        return tokenDict
    }
    
    // MARK: 로그인 버튼 동작
    @IBAction func didTapLoginBtn(_ sender: Any) {
        if let email = self.emailTextField.text, let pwd = self.passwordTextField.text {
            // provider email <여기서 쓸거/가져올거> nickname accessToken
            MemberServiceAPIManager().winderLogin(User(email: email, password: pwd)) { accessToken, nickname, error in
                if let error = error {
                    self.alert(error.localizedDescription, completion: nil)
                } else if let accessToken = accessToken, let nickname = nickname {
                    //1. 액세스토큰 키체인에 저장
                    SecurityUtils().save(SecurityUtils().bundleName, account: "accessToken", value: accessToken)
                    //2. 유저디폴트에 유저정보 저장
                    MemberInfoManager().deviceLogin(userInfoKey: UserInfoKey(loginEmail: email, loginNickname: nickname, provider: "winder"))
                    //3. 프로필화면으로 복귀
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    //+
}

// MARK: -- 텍스트필드 델리게이트
extension LogInVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print("\(#function), \(textField)")
        textField.resignFirstResponder()
        return true
    }
    
    //+
}

// MARK: -- 네이버 로그인 델리게이트
extension LogInVC: NaverThirdPartyLoginConnectionDelegate {
    
    // 로그인 성공했을 때 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("[Success] : Success Naver Login")
        self.getLoginInfoFromNaverDelegate()
    }
    
    // 접근할 토큰 갱신
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        //code
    }
    
    // 로그아웃 할 경우 호출(토큰 삭제)
    func oauth20ConnectionDidFinishDeleteToken() {
        //self.naverLoginInstance?.requestDeleteToken()
    }
    
    // 모든 Error
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("[Naver Login Error] :", error.localizedDescription)
    }

    // 로그인했을 때 동작 커스텀
    func getLoginInfoFromNaverDelegate() {
        guard let isValidAccessToken = self.naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return
        }
        if !isValidAccessToken { return }
        
        guard let refreshToken = self.naverLoginInstance?.refreshToken else { return }
        guard let accessToken = self.naverLoginInstance?.accessToken else { return }
        //print("\(#function), \(accessToken), \(refreshToken)")
        let tokenInfo = TokenInfo(accessToken: self.setNaverTokenInfo(accessToken),
                                  refreshToken: self.setNaverTokenInfo(refreshToken),
                                  provider: "naver"
        )
        
        MemberServiceAPIManager().pushTokenFromNaverLogin(tokenInfo) { email, nickname, error in
            if let error = error {
                self.alert(error.localizedDescription, completion: nil)
            } else if let email = email, let nickname = nickname {
                //1. 액세스토큰 키체인에 저장
                SecurityUtils().save(SecurityUtils().bundleName, account: "accessToken", value: accessToken)
                SecurityUtils().save(SecurityUtils().bundleName, account: "refreshToken", value: refreshToken)
                //2. 유저디폴트에 유저정보 저장
                MemberInfoManager().deviceLogin(userInfoKey: UserInfoKey(loginEmail: email, loginNickname: nickname, provider: "naver"))
                //3. 프로필화면으로 복귀
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    func setNaverTokenInfo(_ token: String) -> TokenAndExpiredDict {
        let tokenDict: TokenAndExpiredDict = [
                "token": "\(token)",
                "expireAt": "",
                "expireIn": "",
        ]
        return tokenDict
    }
    
    //+
}
