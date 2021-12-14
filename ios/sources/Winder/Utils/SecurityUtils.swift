//
//  SecurityUtils.swift
//  Winder
//
//  Created by 이동규 on 2021/11/15.
//

import Foundation

// 관련 모듈
import Security
import Alamofire

enum AccountType: String {
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
    case email = "email"
}

class SecurityUtils {
    
    let bundleName: String = "com.winder.Winder"
    
    
    // 1. 키체인에 값을 저장하는 메소드(서비스:번들아이디, 어카운드:사용자이메일, 값:토큰문자열
    func save(_ service: String, account: String, value: String) {
        // 키체인 쿼리 정의
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,    // 아이템 클래스
            kSecAttrService: service,    // 서비스 아이디. 키체인에서 해당 앱을 식별하기 위한 값.
            kSecAttrAccount: account,    // 사용자 계정
            kSecValueData: value.data(using: .utf8, allowLossyConversion: false)!    // 저장할 값
        ]
        // 기존에 저장된 값 삭제
        SecItemDelete(keyChainQuery)
        // 새로운 값 추가
        let status: OSStatus = SecItemAdd(keyChainQuery, nil)
        assert(status == noErr, "토큰 값 저장에 실패했습니다.")
        NSLog("status=\(status)")
    }
    
    
    // 2. 키체인 값을 불러오는 메소드
    func load(_ service: String, account: String) -> String? {
        // 키체인 쿼리 정의
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,    // 아이템 클래스
            kSecAttrService: service,    // 서비스 아이디
            kSecAttrAccount: account,    // 사용자 계정
            kSecReturnData: kCFBooleanTrue!, //CFDataRef
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        // 키체인에 저장된 값 읽어오기
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(keyChainQuery, &dataTypeRef)
        
        // 처리 결과가 성공이라면 읽어온 값을 Data 타입으로 변환하고, 다시 String 타입으로 변환
        if (status == errSecSuccess) {
            let retrievedData = dataTypeRef as! Data
            let value = String(data: retrievedData, encoding: .utf8)
            return value
        } else {
            print("키체인으로 부터 되돌아 온 데이터가 없습니다. Status code: \(status)")
            return nil
        }
    }
    
    // 3. 키체인에 저장된 값 삭제
    func delete(_ service: String, account: String) {
        // 키체인 정의
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,    // 아이템 클래스
            kSecAttrService: service,
            kSecAttrAccount: account
        ]
        // 값 삭제
        let status = SecItemDelete(keyChainQuery)
        assert(status == noErr, "토큰 값 삭제에 실패했습니다.")
        NSLog("status=\(status)")
    }
    
    // 4. 인증헤더 만들기
    func getAuthorizationHeader() -> HTTPHeaders? {
        let serviceID = "com.winder.Prototype-APILogin"
        if let accessToken = self.load(serviceID, account: "accessToken") {
            return ["Authorization" : "Bearer \(accessToken)"] as HTTPHeaders
        } else {
            return nil
        }
    }
    
}

// MARK: 사용방식 정리
/*
 사용: 로그인 버튼 누르면 API 결과 파싱하고 쓸거 쓸고 한다음 토큰 키체인에 저장
 1. 토큰정보 추출
 2. 토큰 정보 키체인에 저장
 let tk = SecurityUtils()
 tk.save("com.winder.Prototype-APILogin", account: "accessToken", value: accessToken)
 3. 이제 화면이 viewdidload 할때 tk.load 쓰면 된다.
 */
