//
//  MemberUserModel.swift
//  Winder
//
//  Created by 이동규 on 2021/11/15.
//

import Foundation

struct User: Codable {
    var email: String
    var password: String
}

struct ValidEmail: Codable {
    var email: String
}

enum TokenType {
    case access
    case refresh
}

typealias TokenAndExpiredDict = Dictionary<String, String>

struct TokenInfo: Codable {
    var accessToken: TokenAndExpiredDict
    var refreshToken: TokenAndExpiredDict
    var provider: String    //kakao, naver
}
