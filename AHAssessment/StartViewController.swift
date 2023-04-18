//
//  StartViewController.swift
//  AHAssessment
//
//  Created by Sergei Podnebesnyi on 18.04.2023.
//

import UIKit

class StartViewController: UIViewController {

    private var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: UIScreen.main.bounds.height/2, width: UIScreen.main.bounds.width, height: 50))
        label.textAlignment = .center
        label.text = "Storyboard removed"
        return label
      } ()
      
      override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        view.addSubview(label)
      }

}

