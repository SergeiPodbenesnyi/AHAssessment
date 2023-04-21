//
//  CollectionViewController.swift
//  AHAssessment
//
//  Created by Sergei Podnebesnyi on 18.04.2023.
//

import UIKit

class CollectionViewController: UIViewController,
                                UICollectionViewDelegate,
                                UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout {
    
    private var barSize = 44.0
    private var cellSide = SizeConstants.screenWidth / 2 - SizeConstants.preferredInset * 1.5
    private var artCollectionView: UICollectionView?
    private var dataProvider: DataProvider
    private var artTypes: [ArtType] = []
    private var artTypesDict: [String: ArtType] = [:]
    
    
    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = TextConstants.collectionVCTitle
        view.backgroundColor = ColorConstants.collectionVCBackgroundColor
        
        getArtTypes()
        setupDismissButton()
        setupCollectionView()
    }
    
    
    override func viewWillLayoutSubviews() {
        let frame = self.view.frame
        self.artCollectionView?.frame = CGRectMake(frame.origin.x, frame.origin.y + barSize, frame.size.width, frame.size.height - barSize)
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
    
    
    private func setupCollectionView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: cellSide, height: cellSide)
        flowLayout.sectionInset = UIEdgeInsets(top: SizeConstants.preferredInset,
                                               left: SizeConstants.preferredInset,
                                               bottom: SizeConstants.preferredInset,
                                               right: SizeConstants.preferredInset)
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.headerReferenceSize = CGSize(width: view.frame.width, height: SizeConstants.preferredButtonHeight)
        artCollectionView = UICollectionView(frame: self.view.frame,
                                             collectionViewLayout: flowLayout)
        artCollectionView?.register(ArtObjectCell.self,
                                    forCellWithReuseIdentifier: StringConstants.reusableArtObjectCellIdentifier)
        artCollectionView?.register(ArtTypeHeaderView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: StringConstants.collectionHeaderIdentifier )
        artCollectionView?.backgroundColor = UIColor.white
        view.addSubview(artCollectionView ?? UICollectionView())
        
        artCollectionView?.delegate = self
        artCollectionView?.dataSource = self

    }
    
    
    private func getArtTypes() {
        dataProvider.getArtTypes { [weak self] result in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let artTypes):
                    strongSelf.artTypes = artTypes
                    for artType in artTypes {
                        strongSelf.artTypesDict[artType.name] = artType
                    }
                    strongSelf.artCollectionView?.reloadData()
                }
                
                DispatchQueue.global().async { [weak self] in
                    guard let strongSelf = self else { return }
                    for i in 0..<strongSelf.artTypes.count {
                        let artType = strongSelf.artTypes[i]
                        strongSelf.dataProvider.getArtObjectsForType(artType: artType.name,
                                                                    onFinish: { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .failure(let error):
                                    print(error)
                                case .success(let artObjects):
                                    strongSelf.artTypes[i].artObjects = artObjects
                                    strongSelf.artCollectionView?.reloadSections(IndexSet(integer: i))
                                }
                            }
                        })
                    }
                }
            }
            
        }
    }
    
    
    // Due to a bug in Swift related to generic subclases, we have to specify ObjC delegate method name
    // if it's different than Swift name (https://bugs.swift.org/browse/SR-2817).
    @objc (collectionView:viewForSupplementaryElementOfKind:atIndexPath:)
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil

        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView =
            collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: StringConstants.collectionHeaderIdentifier,
                for: indexPath as IndexPath) as! ArtTypeHeaderView
            headerView.title = artTypes[indexPath.section].name
            reusableView = headerView
        }
        return reusableView!
    }
    
    //MARK UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return artTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artTypes[section].artObjects.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let artCell = collectionView.dequeueReusableCell(withReuseIdentifier: StringConstants.reusableArtObjectCellIdentifier,
                                                        for: indexPath) as? ArtObjectCell
        guard let artCell = artCell else { return UICollectionViewCell() }
        artCell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        artCell.layer.cornerRadius = SizeConstants.preferredCellCornerRadius
        artCell.isLoading = false
        artCell.imageView.image = nil
        artCell.currentUrl = nil
        let artObject = artTypes[indexPath.section].artObjects[indexPath.item]
        artCell.text = artObject.title
    
        let image = artObject.image
        
        if (image == nil) {
            artCell.currentUrl = artObject.webImageUrl
            artCell.isLoading = true
            DispatchQueue.global().async { [weak self, indexPath] in
                guard let strongSelf = self else {
                    artCell.isLoading = false
                    return
                }
                let newImage = artCell.resizedImage(at: URL(string: artObject.webImageUrl)!,
                                                    for: CGSize(width: strongSelf.cellSide,
                                                                height: strongSelf.cellSide))
                
                DispatchQueue.main.async { [weak self, indexPath] in
                    if artCell.currentUrl == artObject.webImageUrl {
                        artCell.isLoading = false
                        artCell.imageView.image = newImage
                    }
                    self?.artTypes[indexPath.section].artObjects[indexPath.item].image = newImage
                }
            }
        } else {
            artCell.imageView.image = image
        }
        
        return artCell
    }
    
    //MARK UICollectionViewDelegate
}
