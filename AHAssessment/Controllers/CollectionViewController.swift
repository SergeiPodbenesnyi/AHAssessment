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
    
    var router: Router
    private var cellSide = SizeConstants.screenWidth / 2 - SizeConstants.preferredInset * 1.5
    private var artCollectionView: UICollectionView?
    private var dataProvider: DataProvider
    private var artTypes: [ArtType] = []
    private var currentSection = 1
    private var totalSections = 1
    
    
    init(dataProvider: DataProvider, router: Router) {
        self.dataProvider = dataProvider
        self.router = router
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
        self.artCollectionView?.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)
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
            
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .failure(let error):
                    self?.showErrorAlert(error)
                case .success(let artTypes):
                    strongSelf.artTypes = artTypes
                    strongSelf.artCollectionView?.reloadData()
                    strongSelf.totalSections = artTypes.count
                    
                    for i in 0..<3 {
                        strongSelf.updateObjectsInSection(atIndex: i)
                        strongSelf.currentSection = i
                    }
                }
            }
            
        }
    }
    
    
    private func updateObjectsInSection(atIndex index: Int) {
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else { return }
            let artType = strongSelf.artTypes[index]
            strongSelf.dataProvider.getArtObjectsForType(artType: artType.name,
                                                         onFinish: { result in
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    switch result {
                    case .failure(let error):
                        strongSelf.showErrorAlert(error)
                    case .success(let artObjects):
                        strongSelf.artTypes[index].artObjects = artObjects
                        strongSelf.artCollectionView?.reloadSections(IndexSet(integer: index))
                    }
                }
            })
        }
    }
    
    
    //MARK: UICollectionViewDataSource
    
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
    
    //MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if artTypes.count > indexPath.section {
            let artType = artTypes[indexPath.section]
            if artType.artObjects.count > indexPath.item {
                let artObject = artType.artObjects[indexPath.item]
                let detailsVC = router.getDetailsViewController(artObject: artObject)
                navigationController?.pushViewController(detailsVC, animated: true)
            }
        }
    }
    
    //MARK: Alerts
    
    func showErrorAlert(_ error: Error) {
        let alert = UIAlertController(title: "Something went wrong",
                                      message: "Error description: \(error.localizedDescription)",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .destructive))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: ScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let indexPaths = artCollectionView?.indexPathsForVisibleItems {
            for indexPath in indexPaths {
                if indexPath.section >= currentSection && indexPath.section < totalSections - 1  {
                    currentSection += 1
                    updateObjectsInSection(atIndex: currentSection)
                }
            }
        }
    }
}
