//
//  SignUpVC.swift
//  Winder
//
//  Created by 이동규 on 2021/11/15.
//

import Foundation
import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var inputEmailTextField: UITextField! { didSet { inputEmailTextField.delegate = self } }
    @IBOutlet weak var validEmailTextField: UITextField! { didSet { validEmailTextField.delegate = self } }
    @IBOutlet weak var inputPwdTextField: UITextField! { didSet { inputPwdTextField.delegate = self } }
    @IBOutlet weak var validPwdTextField: UITextField! {
        didSet {
            validPwdTextField.delegate = self
            validPwdTextField.accessibilityValue = "LastTF"
        }
    }
    
    var keyHeight: CGFloat = 0.0
    
    @IBOutlet weak var validEmailBtn: UIButton!
    @IBOutlet weak var validNumberBtn: UIButton!
    
    @IBOutlet weak var emailValidMessageLabel: UILabel!
    @IBOutlet weak var numberValidMessageLabel: UILabel!
    
    var validEmailNumber: String?   //이메일 인증 번호 누르고 리턴받은 인증번호 프로퍼티
    var isValidEmail: Bool = false
    var isValidNumber: Bool = false
    
    let MessageValidEmailUtils = ["✅ 이메일로 인증번호를 보냈습니다.", "⛔️ 이메일을 다시 확인해주세요.", "ℹ️ 이메일을 입력하고 인증버튼을 클릭해 주세요."]
    let MessageValidNumberUtils = ["✅ 인증번호가 확인되었습니다.", "⛔️ 인증번호가 틀렸습니다.", "ℹ️ 이메일로 전송된 인증번호를 입력해주세요."]
    
    
    // MARK: 이메일 인증번호 요청 버튼
    @IBAction func didTapValidEmailBtn(_ sender: UIButton) {
        if let email = self.inputEmailTextField.text {
            MemberServiceAPIManager().isValidEmail(ValidEmail(email: email)) { validNumStr, error in
                if let error = error {
                    self.alert(error.localizedDescription, completion: nil)
                    self.emailValidMessageLabel.text = self.MessageValidEmailUtils[1]
                } else if let validNumStr = validNumStr {
                    self.validEmailNumber = validNumStr
                    self.isValidEmail = true
                    self.alert("이메일로 인증번호를 보냈습니다.", completion: nil)
                    self.emailValidMessageLabel.text = self.MessageValidEmailUtils[0]
                    print("valid number: \(self.validEmailNumber ?? "")")
                }
            }
        }
    }
    
    // MARK: 이메일로 전송된 인증번호와 검증
    @IBAction func didTapValidNumberBtn(_ sender: Any) {
        if let inputNumber = self.validEmailTextField.text {
            if let validNumber = self.validEmailNumber {
                if inputNumber == validNumber {
                    self.isValidNumber = true
                    self.alert("정답입니다.", completion: nil)
                    self.numberValidMessageLabel.text = self.MessageValidNumberUtils[0]
                } else {
                    self.alert("인증 번호를 다시 확인해주세요.", completion: nil)
                    self.numberValidMessageLabel.text = self.MessageValidNumberUtils[1]
                }
            }
        }
    }
    
    // MARK: 가입완료 버튼 동작(개인정보 서버푸쉬 - 리턴데이터(액세스 토큰) 키체인 저장, 유저정보 UserDefaults에 저장)
    @IBAction func didTapEnrollBtn(_ sender: UIButton) {
        if self.isValidEmail == true && self.isValidNumber == true {
            if let pwd = self.inputPwdTextField.text,
               let pwdValid = self.validPwdTextField.text,
               let email = self.inputEmailTextField.text {
                if pwd == pwdValid {
                    // 1. 서버에 유저정보 푸쉬
                    MemberServiceAPIManager().Enroll(User(email: email, password: pwd)) { accessToken, nickname, error in
                        if let error = error {
                            self.alert(error.localizedDescription, completion: nil)
                        } else if let accessToken = accessToken, let nickname = nickname {
                            // 2. 리턴된 토큰 키체인 저장
                            SecurityUtils().save(SecurityUtils().bundleName, account: "accessToken", value: accessToken)
                            // 3. 유저정보 유저디폴트에 저장
                            MemberInfoManager().deviceLogin(userInfoKey: UserInfoKey(loginEmail: email, loginNickname: nickname, provider: "winder"))
                            // 4. 프로필 화면으로 복귀
                            DispatchQueue.main.async {
                                //디스미스
                                self.performSegue(withIdentifier: "ID-unwindToProfileTVC", sender: self)
                            }
                        }
                    }
                } else {
                    self.alert("비밀번호를 다시 확인해주세요.", completion: nil)
                    if self.validPwdTextField.isFirstResponder {
                        self.validPwdTextField.resignFirstResponder()
                    }
                }
            }
        } else {
            self.alert("이메일 인증이 필요합니다.", completion: nil)
            if self.validPwdTextField.isFirstResponder {
                self.validPwdTextField.resignFirstResponder()
            }
        }
    }
    
    // MARK: 리프레시 버튼 동작
    @IBAction func didTapRefreshBtn(_ sender: Any) {
        self.initParams()
    }
    
    // MARK: 로그인페이지로 되돌아가기
    @IBAction func didTapDismissBtn(_ sender: Any) {
        //디스미스 전에 입력으로 바뀐 프로퍼티들 초기화(뷰딛로에서 해도 될지도?)
        //
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: 유틸 함수들
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initParams()
        self.setUpKeyboardNotification()
    }
    
    private func initParams() {
        self.validEmailNumber = nil
        self.isValidEmail = false
        self.isValidNumber = false
        self.emailValidMessageLabel.text = self.MessageValidEmailUtils[2]
        self.numberValidMessageLabel.text = self.MessageValidNumberUtils[2]
    }
    
    private func setUpKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if keyHeight <= self.view.frame.height - keyboardSize.height {
                return
            }
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        self.keyHeight = 0
    }
    //+
}

// MARK: -- 텍스트필드 델리게이트
extension SignUpVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.accessibilityValue == "LastTF" {
            self.keyHeight = textField.frame.origin.y + textField.frame.height
        } else {
            self.keyHeight = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print("\(#function), \(textField)")
        textField.resignFirstResponder()
        return true
    }
    
    //+
}
