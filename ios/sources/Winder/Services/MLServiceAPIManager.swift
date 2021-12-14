//
//  MLServiceAPIManager.swift
//  Winder
//
//  Created by 이동규 on 2021/11/12.
//

import Foundation

class MLServiceAPIManager {
    
    func uploadPictureAndGetResult(_ imageModel: CapturedImageModel, completion: @escaping (String?)->()) {
        
        let boundary = UUID().uuidString
        let url = URL(string: "https://winder.info/api/v1/image")!
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
        dataForUpload.append(imageModel.capturedImage.pngData()!)
        // 모든 내용 끝나는 곳에 --(boundary)--로 표시해준다.
        dataForUpload.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        URLSession.shared.uploadTask(with: request, from: dataForUpload) { (data, response, error) in
            if let error = error {
                NSLog("hererere!!!\n",error.localizedDescription)
                completion(nil)
            } else if let data = data {
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    if let json = jsonData as? [String: Any] {
                        print(json)
                    }
            } else if let response = response {
                print(response)
            }
        }.resume()
    }
}
