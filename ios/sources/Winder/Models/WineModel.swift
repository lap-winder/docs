//
//  WineModel.swift
//  Winder
//
//  Created by 이동규 on 2021/11/17.
//

import Foundation
import UIKit

//MARK: 와인 셀 정보관련
typealias WineCellImageDict = Dictionary<String, String>    //wine_bottle, country_flag
	
struct WineCell: Codable {
	var id: Int64
	var name: String
	var rating: String
	var price: String
	var currency: String
	var country: String
	var region: String
	var winery: String
	var image: WineCellImageDict
}

struct WineCellList: Codable {
	var search: [WineCell]
}

//MARK: 와인 디테일 정보 관련
typealias WineDetailDict = Dictionary<String, String>

struct WineDetailInfo: Codable {
	var id: Int64
	var name: String
	var name_kr: String
	var description: String
}

struct WineDetail: Codable {
	var id: Int64
	var name: String
	var name_kr: String
	var rating: Double
	var price: Int64
	var currency: String
	var description: String
	var characters: WineDetailDict
	var wine_type: WineDetailInfo
	var country: WineDetailInfo
	var region: WineDetailInfo
	var winery: WineDetailInfo
	var wine_style: WineDetailInfo
	var grapes: [WineDetailInfo]
	var images: WineCellImageDict
}

//MARK: 와인 정보 뷰모델
class WineModel {
	
	var wineCellList = [WineCell]()
	
	// MARK: 서버API 에서 로딩
	func loadFromAPI(completion: @escaping () -> ()) {
		SearchWineAPIManager().loadWineList() { data, error in
			if let error = error {
				print(#function, error.localizedDescription)
			} else if let data = data {
				print(data)
				do {
					let result = try JSONDecoder().decode(WineCellList.self, from: data)
					let searchWineCellList = result.search
					DispatchQueue.main.async {
						self.wineCellList = searchWineCellList
						completion()
					}
				} catch {
					print("error")
				}
			}
		}
	}
	
	// MARK: 서버API 에서 로딩
	func loadDetailFromAPI(wineID: Int64, completion: @escaping (WineDetail?) -> ()) {
		SearchWineAPIManager().loadWineDetail(id: wineID) { data, error in
			if let error = error {
				print(#function, error.localizedDescription)
			} else if let data = data {
				do {
					let result = try JSONDecoder().decode(WineDetail.self, from: data)
					completion(result)
				} catch {
					print(error.localizedDescription)
					completion(nil)
				}
			} else {
				completion(nil)
			}
		}
	}
	
	// MARK: 이미지 업로드 및 서버API 에서 로딩
	func loadDetailFromAPIByImage(_ imageModel: CapturedImageModel, completion: @escaping (WineDetail?, Error?) -> ()) {
		SearchWineAPIManager().uploadPictureAndGetResult(imageModel) { data, error in
			if let error = error {
				print(#function, error.localizedDescription)
				completion(nil, error)
			} else if let data = data {
				do {
					let result = try JSONDecoder().decode(WineDetail.self, from: data)
					completion(result, nil)
				} catch {
					print(error.localizedDescription)
					completion(nil, error)
				}
			} else {
				completion(nil, nil)
			}
		}
	}
	
	//+
}
