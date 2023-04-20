//
//  DataProvider.swift
//  AHAssessment
//
//  Created by Sergei Podnebesnyi on 20.04.2023.
//

import Foundation

typealias ArtTypesResult = Result<[ArtType], Error>
typealias ArtObjectsResult = Result<[ArtObject], Error>

protocol DataProvider: AnyObject {
    func getArtTypes(onFinish: @escaping (ArtTypesResult) -> Void)
    func getArtObjectsForType(artType: String, onFinish: @escaping (ArtObjectsResult) -> Void)
}
