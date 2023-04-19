//
//  JSONDataProvider.swift
//  AHAssessment
//
//  Created by Sergei Podnebesnyi on 19.04.2023.
//

import Foundation
	

class JSONDataProvider {
    
    private let appConfig = AppConfiguration()
    
    init() {
        
    }
    
    func postRequest(completion: @escaping ([String: Any]?, Error?) -> Void) {
        
        let apiKey = appConfig.getConfig(AppConfiguration.rijksApiKey)
        let url = URL(string: "https://www.rijksmuseum.nl/api/en/collection?key=\(apiKey)&imgonly=true")!

        let session = URLSession.shared

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }

            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    completion(nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
                    return
                }
                print(json)
                completion(json, nil)
            } catch let error {
                print(error.localizedDescription)
                completion(nil, error)
            }
        })

        task.resume()
    }
}
