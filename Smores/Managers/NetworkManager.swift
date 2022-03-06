//
//  NetworkManager.swift
//  SmoreProject
//
//  Created by Suha Baobaid on 3/5/22.
//

import Foundation

class NetworkManager {
    static let shared: NetworkManager = NetworkManager()
    
    
    func convertFormField(named name: String, value: String, using boundary: String) -> String {
      var fieldString = "--\(boundary)\r\n"
      fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
      fieldString += "\r\n"
      fieldString += "\(value)\r\n"

      return fieldString
    }

    func convertFileData(fieldName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        var data = Data()
        
        data.append("--\(boundary)\r\n")
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"\r\n")
        data.append("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.append("\r\n")
        
        return data
    }

    func uploadImage(imageData: Data, completionHandler: @escaping (Result<Data, ErrorMessages>) -> Void) {
        let boundary = "Boundary-\(UUID().uuidString)"

        var request = URLRequest(url: URL(string: "https://api-stage.somethingmoreapp.com/photo/test")!)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = [
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
        ]

        var httpBody = Data()

        httpBody.append(convertFileData(fieldName: "photo",
                                        mimeType: "file",
                                        fileData: imageData,
                                        using: boundary))

        httpBody.append("--\(boundary)--\r\n")

        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { data, response, error in
            print(response)
            if let data = data {
                let jsonDecoder = JSONDecoder()
                let decodedData = try? jsonDecoder.decode(ImageResponse.self, from: data)
                print(decodedData)
            }
        }.resume()

    }
    

}


extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
