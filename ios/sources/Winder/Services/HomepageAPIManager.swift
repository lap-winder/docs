//
//  HomepageAPIManager.swift
//  Winder
//
//  Created by 이동규 on 2021/11/12.
//

// 리턴데이터키값: owner, content, thumbnail_url, id, title, member_id, create_at, updated_at, view_count
import Foundation

// 홈페이지 뷰의 서버 리퀘스트 관련 뷰모델 정리
class HomepageAPIManager {

    func requestContentsInfo(_ info: HomeContentInfo, completion: @escaping ([NSDictionary]?, Error?)->()) {
        let urlStr = getURLString(contentsType: info.label.rawValue, numberOfPages: info.page)
        var request = URLRequest(url: URL(string: urlStr)!)
        request.httpMethod = "GET"
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //It'sEmptyBody
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog(error.localizedDescription)
                completion(nil, error)
            } else if let data = data {
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                if let jsonObjData = jsonData?["data"] as? [NSDictionary] {
                    //print("jsonObjData: \(jsonObjData), type: \(type(of: jsonObjData)), type1: \(type(of: jsonObjData[0])), count: \(jsonObjData.count)")
                    DispatchQueue.main.async {
                        completion(jsonObjData, nil)
                    }
                } else if let response = response {
                    print("response: \(response)")
                    NSLog("Wrong request")
                    completion(nil, nil)
                }
            }
        }.resume()
    }
    
    private func getURLString(contentsType: String, numberOfPages: Int) -> String {
        let result = "https://winder.info/api/v1/post?label=\(contentsType)&page=\(numberOfPages)"
        return result
    }
    
    func requestContentsURL(_ contentID: String, completion: @escaping (String?, Error?)->()) {
        let urlStr = "https://winder.info/api/v1/post/\(contentID)"
        var request = URLRequest(url: URL(string: urlStr)!)
        request.httpMethod = "GET"
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //It'sEmptyBody
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog(error.localizedDescription)
                completion(nil, error)
            } else if let data = data {
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                if let jsonObjData = jsonData?["data"] as? NSArray {
                    if let jsonKeyData = jsonObjData[0] as? NSDictionary {
                        if let returnedContentURL = jsonKeyData["content"] as? String {
                            DispatchQueue.main.async {
                                completion(returnedContentURL, nil)
                            }
                        }
                    }
                } else if let response = response {
                    print("response: \(response)")
                    NSLog("Wrong request")
                    completion(nil, nil)
                }
            }
        }.resume()
    }
    
    //+
}
