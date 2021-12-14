//
//  HomeContentInfo.swift
//  Winder
//
//  Created by 이동규 on 2021/11/12.
//

import Foundation

enum ContentsCase: String {
    case news = "news"
    case recommend  = "recommend"
    case blog  = "blog"
    case info  = "info"
    case food  = "food"
}

struct HomeContentInfo {
    var label: ContentsCase     //컨텐츠 라벨링(recommend, news, blog, info)
    var page: Int               // 컨텐츠 페이지
}
