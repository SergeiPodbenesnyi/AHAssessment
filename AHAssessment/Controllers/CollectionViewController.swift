//
//  CollectionViewController.swift
//  AHAssessment
//
//  Created by Sergei Podnebesnyi on 18.04.2023.
//

import UIKit

class CollectionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = TextConstants.collectionVCTitle
        view.backgroundColor = ColorConstants.collectionVCBackgroundColor
        	
        setupDismissButton()
    }
    
    private func setupDismissButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: TextConstants.dismissButtonTitle,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(dismissSelf))
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
}
