//
//  CollectionHeaderView.swift
//  AHAssessment
//
//  Created by Sergei Podnebesnyi on 20.04.2023.
//

import UIKit

class ArtTypeHeaderView: UICollectionReusableView {
    var title: String? {
        set { titleLabel.text = newValue?.capitalized }
        get { titleLabel.text }
    }
    private var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        titleLabel.frame = CGRect(x: 12, y: 0, width: self.frame.width, height: self.frame.height)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .black
        addSubview(titleLabel)
        setGradientBackground()
        backgroundColor?.withAlphaComponent(0.5)
    }
    
    func setGradientBackground() {
        let colorLeft =  UIColor.lightGray.cgColor
        let colorRight = UIColor.white.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorLeft, colorRight]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at:0)
    }
}
