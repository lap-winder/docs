//
//  ProfileTVC.swift
//  Winder
//
//  Created by 이동규 on 2021/11/15.
//

import Foundation
import UIKit

class ProfileTVC: UITableViewController {
    
    @IBOutlet weak var profilebackView: UIView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    let cellIdentifiers = [
        "cell": "ID-ProfileCell"
    ]
    
    let userArchives: [String] = ["선호하는 와인", "내가 평가한 와인", "북마크 리스트"]
    let otherInfo: [String] = ["Winder 소개", "서비스 이용약관", "개인정보 취급방침"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProfileViewSection()
        setUpLogInandOutCell()
        setUptableView()
    }
    
    func setUptableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setUpProfileViewSection() {
        self.profilebackView.layer.cornerRadius = 20
        self.profilebackView.backgroundColor = UIColor(displayP3Red: 126/255, green: 54/255, blue: 254/255, alpha: 1.0)
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
        //self.profileImageView.image = UIImage(named: "profile_sample.png")
        self.editProfileBtn.layer.cornerRadius = self.editProfileBtn.frame.height / 2
        self.loginBtn.layer.cornerRadius = self.loginBtn.frame.height / 4
        self.loginBtn.backgroundColor = UIColor(displayP3Red: 1/255, green: 4/255, blue: 48/255, alpha: 1.0)
        //self.loginBtn.isHidden = true
    }
    
    func setUpLogInandOutCell() {
        //
    }
    
    @IBAction func didTapEditProfileBtn(_ sender: Any) {
        if let _ = SecurityUtils().load(SecurityUtils().bundleName, account: "accessToken") {
            self.performSegue(withIdentifier: "ID-manual-ProfileTVC-EditProfileVC", sender: self)
        } else {
            self.alert("로그인 후 이용해 주세요.", completion: nil)
        }
    }
    
    @IBAction func didTapLoginBtn(_ sender: Any) {
//        self.performSegue(withIdentifier: "ID-manual-ProfileTVC-LogInVC", sender: self)
    }
    
    // MARK: 화면 갱신 시 로그인 여부 확인
    override func viewWillAppear(_ animated: Bool) {
        //1. 프로필 바꾸기
        if let _ = SecurityUtils().load(SecurityUtils().bundleName, account: "accessToken") {
            if let userInfoKey = MemberInfoManager().loadProfile() {
                self.emailLabel.text = userInfoKey.loginEmail
                self.nicknameLabel.text = userInfoKey.loginNickname
                self.loginBtn.isHidden = true
            }
        } else {
            setProfileInit()
        }
        
        //2. 유저아카이브 섹션 막기
    }
    
    private func setProfileInit() {
        self.nicknameLabel.text = "dongklee"
        self.emailLabel.text = "lap.winder@gmail.com"
        //self.profileImageView.image = UIImage(named: "profile_sample.png")
        self.loginBtn.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ID-action-ProfileTVC-LogInVC" {
            if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "ID-LogInVC") as? LogInVC {
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true, completion: nil)
            }
        } else if segue.identifier == "ID-manual-ProfileVC-PrivacyInfoVC" {
            guard let privacyVC = self.storyboard?.instantiateViewController(withIdentifier: "ID-PrivacyInfoVC") as? PrivacyInfoVC else { return }
            privacyVC.paramContentsURL = "https://winder.info/terms"
            //privacyVC.modalPresentationStyle = .fullScreen
            self.present(privacyVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func unwindFromSignUpVC (segue : UIStoryboardSegue) {}
    
    //+
}

// MARK: -- UITableViewDelegate, UITableViewDataSource 익스텐션으로 분기
extension ProfileTVC {
    
    // 원하는 섹션 개수
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {  // 각 섹션마다 다른 갯수를 돌려줄 것
            case 0:  // tableView의 section은 0부터 시작
                return userArchives.count  // 한글 array의 갯수만큼 돌려줌
            case 1:
                return otherInfo.count  // 영어 array의 갯수만큼 돌려줌
            default:
                return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "User Archives" : "Informations"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //순서: 셀인스턴스생성 - 셀로우랑 결합 - 데이터뭐로할건지 - 리턴
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: self.cellIdentifiers["cell"]!, for: indexPath)
        
        let text: String = indexPath.section == 0 ? self.userArchives[indexPath.row] : self.otherInfo[indexPath.row]
        
        cell.textLabel?.text = text  // 셀에 표현될 데이터
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let _ = SecurityUtils().load(SecurityUtils().bundleName, account: "accessToken") {
                //할 행동
                if let cell = tableView.cellForRow(at: indexPath) {
                    print("--->\(cell) \(indexPath.row)")
                }
                tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
                //
            } else {
                self.alert("로그인 후 이용해 주세요.", completion: nil)
                tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
            }
        } else if indexPath.section == 1 {
            self.performSegue(withIdentifier: "ID-manual-ProfileVC-PrivacyInfoVC", sender: indexPath)
            tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        }
    }
    
    //+
}
