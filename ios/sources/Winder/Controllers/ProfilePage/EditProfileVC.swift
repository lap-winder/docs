//
//  EditProfileVC.swift
//  Winder
//
//  Created by 이동규 on 2021/11/15.
//

import Foundation
import UIKit
import KakaoSDKUser
import NaverThirdPartyLogin

class EditProfileVC: UIViewController {
    
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    @IBOutlet weak var tableView: UITableView!
    
    let cellList = ["프로필 사진 변경", "닉네임 변경"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func didTapLogoutBtn(_ sender: Any) {
        
        if let userInfo = MemberInfoManager().loadProfile() {
            //카카오일 때 삭제방법
            if userInfo.provider == "kakao" {
                UserApi.shared.logout { error in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("logout() success.")
                    }
                }
            } else if userInfo.provider == "naver" {
                print(#function, "login with naver")
                self.naverLoginInstance?.requestDeleteToken()
            }
        }
        
        // 유저디폴트저장된거 삭제
        MemberInfoManager().deviceLogout()
        
        // 키체인토큰 삭제
        if let _ = SecurityUtils().load(SecurityUtils().bundleName, account: "accessToken") {
            SecurityUtils().delete(SecurityUtils().bundleName, account: "accessToken")
        }
        if let _ = SecurityUtils().load(SecurityUtils().bundleName, account: "refreshToken") {
            SecurityUtils().delete(SecurityUtils().bundleName, account: "refreshToken")
        }
        
        // 프로필 페이지로 돌아가기
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let preVC = self.presentingViewController as? MainTBC else {
            return
        }
        guard let profileVC = preVC.viewControllers?[3] as? ProfileTVC else {
            return
        }
        profileVC.viewWillAppear(true)
    }
    
}

extension EditProfileVC: UITableViewDelegate & UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.cellList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Edit your profile"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "ID-EditProfileCell", for: indexPath)
        
        cell.textLabel?.text = self.cellList[indexPath.row]
        
        return cell
    }
    
    
}
