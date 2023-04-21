//
//  DetailsViewController.swift
//  AHAssessment
//
//  Created by Sergei Podnebesnyi on 18.04.2023.
//

import UIKit

class DetailsViewController: UIViewController, UIScrollViewDelegate {

    private let artObject: ArtObject
    
    var scrollView : UIScrollView!
    var activityIndicator: UIActivityIndicatorView!
    var imageView : UIImageView?
    
    init(artObject: ArtObject) {
        self.artObject = artObject

        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setupSubviews()
        
        downloadImage()
    }
    
    
    private func downloadImage() {
        let task = URLSession.shared.dataTask(with: URL(string:artObject.webImageUrl)!) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                self?.activityIndicator.stopAnimating()
                return
            }

            DispatchQueue.main.async() { [weak self] in
                let image = UIImage(data: data)
                self?.activityIndicator.stopAnimating()
                self?.scrollView.contentSize = image?.size ?? CGSizeZero
                self?.imageView = UIImageView(image: image)
                if let imageView = self?.imageView {
                    self?.scrollView.addSubview(imageView)
                }
            }
        }
        task.resume()
    }
    
    
    private func setupSubviews() {
        
        let longTitleLabel = UILabel()
        longTitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        longTitleLabel.textColor = .black
        longTitleLabel.text = "Title: \(artObject.longTitle)"
        longTitleLabel.numberOfLines = 0
        longTitleLabel.lineBreakMode = .byWordWrapping
        longTitleLabel.preferredMaxLayoutWidth = view.frame.width - 16
        longTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(longTitleLabel)
        
        longTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        longTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        longTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        longTitleLabel.heightAnchor.constraint(equalToConstant: longTitleLabel.intrinsicContentSize.height).isActive = true
        
        let makerLabel = UILabel()
        makerLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        makerLabel.textColor = .black
        makerLabel.text = "Principal or first maker: \(artObject.principalOrFirstMaker)"
        makerLabel.numberOfLines = 0
        makerLabel.lineBreakMode = .byWordWrapping
        makerLabel.preferredMaxLayoutWidth = view.frame.width - 16
        makerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(makerLabel)
        
        makerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        makerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        makerLabel.topAnchor.constraint(equalTo: longTitleLabel.bottomAnchor, constant: 8).isActive = true
        makerLabel.heightAnchor.constraint(equalToConstant: makerLabel.intrinsicContentSize.height).isActive = true
        
        let placesLabel = UILabel()
        placesLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        placesLabel.textColor = .black
        placesLabel.text = "Production places: \(artObject.productionPlaces)"
        placesLabel.numberOfLines = 0
        placesLabel.lineBreakMode = .byWordWrapping
        placesLabel.preferredMaxLayoutWidth = view.frame.width - 16
        placesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placesLabel)
        
        placesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        placesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        placesLabel.topAnchor.constraint(equalTo: makerLabel.bottomAnchor, constant: 8).isActive = true
        placesLabel.heightAnchor.constraint(equalToConstant:
                                                placesLabel.intrinsicContentSize.height).isActive = true
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = .cyan.withAlphaComponent(0.3)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 0.1
        view.addSubview(scrollView)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: placesLabel.bottomAnchor, constant: 8).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .darkGray
        scrollView.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 25).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    //MARK ScrollView delegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
