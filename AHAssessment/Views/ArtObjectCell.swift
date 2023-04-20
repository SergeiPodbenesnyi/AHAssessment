//
//  ArtObjectCell.swift
//  AHAssessment
//
//  Created by Sergei Podnebesnyi on 20.04.2023.
//

import UIKit

class ArtObjectCell: UICollectionViewCell {
    
    var isLoading: Bool = false {
        didSet {
            activityIndicator.isHidden = !isLoading
        }
    }
    var text : String? {
        set {
            label.text = newValue
        }
        get {
            return label.text
        }
    }
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .yellow
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(imageView)
        addSubview(label)
        addSubview(activityIndicator)
        	
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        label.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -3).isActive = true
    }
}
