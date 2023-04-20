//
//  Router.swift
//  AHAssessment
//
//  Created by Sergei Podnebesnyi on 19.04.2023.
//

import UIKit

class Router {
    
    let dataProvider : DataProvider
    
    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }
    
    private func getNavigationControllerWithRoot(root: UIViewController) -> UINavigationController {
        let navVC = UINavigationController(rootViewController: root)
        navVC.modalPresentationStyle = .fullScreen
        return navVC
    }
    
    private func getCollectionViewController() -> UIViewController {
        let collectionVC = CollectionViewController(dataProvider: dataProvider)
        return collectionVC
    }
    
    public func getNavigationWithCollectionViewController() -> UINavigationController {
        let collectionVC = getCollectionViewController()
        let navVC = getNavigationControllerWithRoot(root: collectionVC)
        return navVC
    }
    
}

