//
//  StartViewController.swift
//  AHAssessment
//
//  Created by Sergei Podnebesnyi on 18.04.2023.
//

import UIKit

class StartViewController: UIViewController {

    private var startJourneyButton = UIButton()
    var router: Router? = nil
      
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        setupStartJourneyButton()
    }
    
    private func setupStartJourneyButton() {
        startJourneyButton.setTitle(TextConstants.startJourneyButtonText, for: .normal)
        startJourneyButton.backgroundColor = ColorConstants.startViewControllerBackgroungColor
        startJourneyButton.setTitleColor(ColorConstants.startJourneyButtonTextColor, for: .normal)
        let buttonWidth = SizeConstants.startJourneyButtonWidth
        let buttonHeight = SizeConstants.preferredButtonHeight
        startJourneyButton.frame = CGRect(x: SizeConstants.centerX - buttonWidth / 2,
                                          y: SizeConstants.centerY - SizeConstants.preferredButtonHeight / 2,
                                          width: buttonWidth,
                                          height: buttonHeight)
        startJourneyButton.layer.cornerRadius = SizeConstants.preferredButtonCornerRadius
        
        view.addSubview(startJourneyButton)


        startJourneyButton.addTarget(self, action: #selector(didTapStartJourneyButton),
                                     for: .touchUpInside)

        //Constraints
        startJourneyButton.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: startJourneyButton,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: SizeConstants.startJourneyButtonWidth)
        
        let heightConstraint = NSLayoutConstraint(item: startJourneyButton,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1.0,
                                                  constant: SizeConstants.preferredButtonHeight)
        
        let centerXConstraint = NSLayoutConstraint(item: startJourneyButton,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: view,
                                                   attribute: .centerX,
                                                   multiplier: 1.0,
                                                   constant: 0.0)
        
        let centerYConstraint = NSLayoutConstraint(item: startJourneyButton,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: view,
                                                   attribute: .centerY,
                                                   multiplier: 1.0,
                                                   constant: 0.0)
        view.addConstraints([centerXConstraint, centerYConstraint, widthConstraint, heightConstraint])
        

    }
    
    @objc private func didTapStartJourneyButton() {
        guard let router = router else { return }
        let navVC = router.getNavigationWithCollectionViewController()
        present(navVC, animated: true)
    }

}

