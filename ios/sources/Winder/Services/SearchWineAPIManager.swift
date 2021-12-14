//
//  SearchWineAPIManager.swift
//  Winder
//
//  Created by 이동규 on 2021/11/21.
//

import Foundation
import UIKit

class SearchWineAPIManager {
    
    private let urlCollections = [
//        "setSearchList": "https://076377ce-e57e-4e02-9010-348b5c4be96d.mock.pstmn.io/api/v1/wine/search",
        "setSearchList": "https://winder.info/api/v1/wine/search",
//        "setWineDetail": "https://076377ce-e57e-4e02-9010-348b5c4be96d.mock.pstmn.io/api/v1/wine/details?wine_ids=" // id 뒤에 +로 붙이기
        "setWineDetail": "https://winder.info/api/v1/wine/details?wine_ids="
    ]
    
    // MARK: 와인 셀 데이터 요청, 검색화면 초기 입장
    func loadWineList(completion: @escaping (Data?, Error?) -> ()) {
        var request = URLRequest(url: URL(string: self.urlCollections["setSearchList"]!)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(#function, error.localizedDescription)
                completion(nil, error)
            } else if let data = data {
                completion(data, nil)
            }
        }.resume()
    }
    
    func loadWineDetail(id: Int64, completion: @escaping (Data?, Error?) -> ()) {
        let urlStr = self.urlCollections["setWineDetail"]! + String(id)
        print(urlStr)
        var request = URLRequest(url: URL(string: urlStr)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(#function, error.localizedDescription)
                completion(nil, error)
            } else if let data = data {
                //print(response)
                completion(data, nil)
            }
        }.resume()
    }
    
    func uploadPictureAndGetResult(_ imageModel: CapturedImageModel, completion: @escaping (Data?, Error?) -> ()) {
        let boundary = UUID().uuidString
        let url = URL(string: "https://winder.info/api/v1/wine/search/image")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var dataForUpload = Data()
        // --(boundary)로 시작.
        dataForUpload.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        // 헤더 정의 - 문자열로 작성 후 UTF8로 인코딩해서 Data타입으로 변환해야 함
        dataForUpload.append("Content-Disposition: form-data; name=\"\(imageModel.paramName ?? "")\"; filename=\"\(imageModel.fileName ?? "")\"\r\n".data(using: .utf8)!)
        // 헤더 정의 2 - 문자열로 작성 후 UTF8로 인코딩해서 Data타입으로 변환해야 함, 구분은 \r\n 2번으로 통일.
        dataForUpload.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        // .png 로 파일 전송 준비
        guard let capturedImage = imageModel.capturedImage else { return }
        guard let rotatedImage = capturedImage.rotateImage() else { return }
        dataForUpload.append(rotatedImage.pngData()!)
        // 모든 내용 끝나는 곳에 --(boundary)--로 표시해준다.
        dataForUpload.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        URLSession.shared.uploadTask(with: request, from: dataForUpload) { (data, response, error) in
            if let error = error {
                print(#function, error.localizedDescription)
                completion(nil, error)
            } else if let data = data {
                //print(response)
                completion(data, nil)
            }
        }.resume()
    }

    //+
}
