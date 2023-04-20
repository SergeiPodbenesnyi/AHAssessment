//
//  JSONDataProvider.swift
//  AHAssessment
//
//  Created by Sergei Podnebesnyi on 19.04.2023.
//

import Foundation
	

class JSONDataProvider : DataProvider {

    private let appConfig = AppConfiguration()
    private let apiKey: String
    private let getTypeHttpMethod = "GET"
    private let basicUrlString = "https://www.rijksmuseum.nl/api/en/collection"
    
    init() {
        apiKey = appConfig.getConfig(AppConfiguration.rijksApiKey)
    }
    
    func postRequestForArtTypes(completion: @escaping (ArtTypesResult) -> Void) {
        
        let url = URL(string: "\(basicUrlString)?key=\(apiKey)&imgonly=true&p=0")!
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = getTypeHttpMethod
        
        let task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "dataNilError",
                                            code: -100001, userInfo: nil)))
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    completion(.failure(NSError(domain: "invalidJSONTypeError",
                                                code: -100009, userInfo: nil)))
                    return
                }
                //Looking for name = type
                let facetsJson = json["facets"] as? [[String:Any]]
                let typesJson = facetsJson?.filter {
                    let name = $0["name"] as? String
                    return name == "type"
                }.compactMap {
                    let facets = $0["facets"] as? [[String : Any]]
                    return facets
                }.first
                
                guard let typesJson = typesJson else {
                    return completion(.failure(NSError(domain: "invalidJSONTypeError",
                                                       code: -100009, userInfo: nil)))
                    
                }
                guard let strongSelf = self else {
                    return completion(.failure(NSError(domain:"JSONDataProvider was destroyed",
                                                   code:-1, userInfo: nil)))
                }
                
                let artTypes = strongSelf.populateTypes(typesJson)
                
                completion(.success(artTypes))
            } catch let error {
                completion(.failure(error))
            }
        })
        
        task.resume()
    }
    
    func postRequestForArtObjectsWithType(artType: String, completion: @escaping (ArtObjectsResult) -> Void) {
        let convertedArtType = artType.replacingOccurrences(of: " ", with: "+")
        let url = URL(string: "\(basicUrlString)?key=\(apiKey)&imgonly=true&type=\(convertedArtType)&p=10")!
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = getTypeHttpMethod
        
        let task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "dataNilError",
                                            code: -100001, userInfo: nil)))
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    completion(.failure(NSError(domain: "invalidJSONTypeError",
                                                code: -100009, userInfo: nil)))
                    return
                }
//              Looking for artObjects
                let artObjectsJson = json["artObjects"] as? [[String : Any]]
            
                guard let artObjectsJsonArray = artObjectsJson else {
                    return completion(.failure(NSError(domain: "invalidJSONTypeError",
                                                code: -100009, userInfo: nil)))
                    
                }
                
                if artObjectsJsonArray.isEmpty {
                    return completion(.success([])) //No arts for that category
                }
                
                guard let strongSelf = self else {
                    return completion(.failure(NSError(domain:"JSONDataProvider was destroyed",
                                                   code:-1, userInfo: nil)))
                }
                
                let artObjects = strongSelf.populateArtObjects(artObjectsJsonArray)
            
                completion(.success(artObjects))
                
            } catch let error {
                completion(.failure(error))
            }
        })
        
        task.resume()
    }
    
    private func populateTypes(_ types : [[String : Any]]) -> [ArtType] {

        var artTypes = [ArtType]()

        for type in types {
            let value = type["value"] as? Int64
            guard let value = value else { continue }
            let typeName = type["key"] as? String
            guard let typeName = typeName else { continue }
            let artType = ArtType(name: typeName, value: value, artObjects: [])
            artTypes.append(artType)
        }
        
        return artTypes
    }
    
    private func populateArtObjects(_ artObjectsJson: [[String : Any]]) -> [ArtObject] {
        
        var artObjects = [ArtObject]()
        
        for artObjectJson in artObjectsJson {
            let id = artObjectJson["id"] as? String
            let longTitle = artObjectJson["longTitle"] as? String
            let title = artObjectJson["title"] as? String
            let principalOrFirstMakerArray = artObjectJson["principalOrFirstMaker"] as? [String]
            var principalOrFirstMaker: String? = ""
            if let principalOrFirstMakerArray = principalOrFirstMakerArray {
                for element in principalOrFirstMakerArray {
                    if (principalOrFirstMaker == "") {
                        principalOrFirstMaker = element
                    } else {
                        principalOrFirstMaker = principalOrFirstMaker! + ", " + element
                    }
                }
            }
            let webImageDict = artObjectJson["webImage"] as? [String : Any]
            var webImageUrl: String? = ""
            if let webImageDict = webImageDict {
                webImageUrl = webImageDict["url"] as? String
            }
            
            let headerImgDict = artObjectJson["headerImage"] as? [String : Any]
            var headerImageUrl: String? = ""
            if let headerImgDict = headerImgDict {
                headerImageUrl = headerImgDict["url"] as? String
            }
            
            var productionPlacesArray = artObjectJson["productionPlaces"] as? [String]
            
            var productionPlaces: String? = ""
            if let productionPlacesArray = productionPlacesArray {
                for element in productionPlacesArray {
                    if (productionPlaces == "") {
                        productionPlaces = element
                    } else {
                        productionPlaces = productionPlaces! + ", " + element
                    }
                    
                }
            }
            let artObject = ArtObject(id: id ?? "",
                                      longTitle: longTitle ?? "",
                                      title: title ?? "",
                                      principalOrFirstMaker: principalOrFirstMaker ?? "",
                                      webImageUrl: webImageUrl ?? "",
                                      headerImageUrl: headerImageUrl ?? "",
                                      productionPlaces: productionPlaces ?? "")
            artObjects.append(artObject)
        }
        return artObjects
    }
    
    //MARK: DataProvider
    func getArtTypes(onFinish: @escaping (ArtTypesResult) -> Void) {
        return postRequestForArtTypes(completion: onFinish)
    }
    
    func getArtObjectsForType(artType: String, onFinish: @escaping (ArtObjectsResult) -> Void) {
        return postRequestForArtObjectsWithType(artType: artType, completion: onFinish)
    }
    
}
