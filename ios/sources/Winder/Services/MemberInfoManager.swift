//
//  MemberInfoManager.swift
//  Winder
//
//  Created by 이동규 on 2021/11/15.
//

import Foundation

struct UserInfoKey {
    var loginEmail: String
    var loginNickname: String
    var provider: String
}

class MemberInfoManager {
    
    enum UserInfoType: String {
        case email = "email"
        case nickname = "nickname"
        case provider = "provider"
    }
    
    func loadProfile() -> UserInfoKey? {
        let ud = UserDefaults.standard  // 저장소 객체 불러오기
        if let email = ud.string(forKey: UserInfoType.email.rawValue),
           let nickname = ud.string(forKey: UserInfoType.nickname.rawValue),
           let provider = ud.string(forKey: UserInfoType.provider.rawValue) {
            let userInfoKey = UserInfoKey(loginEmail: email, loginNickname: nickname, provider: provider)
            return userInfoKey
        }
        return nil
    }
    
    func deviceLogin(userInfoKey: UserInfoKey) {
        // 기본저장소에 값 저장
        let ud = UserDefaults.standard  // 저장소 객체 불러오기
        ud.set(userInfoKey.loginEmail, forKey: UserInfoType.email.rawValue)
        ud.set(userInfoKey.loginNickname, forKey: UserInfoType.nickname.rawValue)
        ud.set(userInfoKey.provider, forKey: UserInfoType.provider.rawValue)
        ud.synchronize()        // 동기화 처리
    }
    
    func deviceLogout() {
        // 기본저장소에 저장해둔 값 삭제
        let ud = UserDefaults.standard  // 저장소 객체 불러오기
        ud.removeObject(forKey: UserInfoType.email.rawValue)
        ud.removeObject(forKey: UserInfoType.nickname.rawValue)
        ud.removeObject(forKey: UserInfoType.provider.rawValue)
        ud.synchronize()        // 동기화 처리
        /*
        // 키체인에 저장된 값 삭제
        //let tk = SecurityUtils()
        //tk.delete(tk.bundleName, account: "accessToken")
         */
    }
}
