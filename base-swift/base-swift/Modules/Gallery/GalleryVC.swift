//
//  GalleryVC.swift
//  base-swift
//
//  Created by ThiemNC on 25/05/2024.
//  Copyright © 2024 BaseSwift. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class GalleryVC: BaseViewModelController<GalleryVM> {
    @IBOutlet weak var clvimages: UICollectionView!
    var isWatingLoadmore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.fetchImage()
    }
    
    override func setupUI() {
        super.setupUI()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        clvimages.delegate = self
        clvimages.dataSource = self
        clvimages.register(UINib(nibName: "GalleryIconCell", bundle: nil), forCellWithReuseIdentifier: "GalleryIconCell")
    }
    
    override func handlerAction() {
        super.handlerAction()
    }
    
    override func setupBinding() {
        super.setupBinding()
        guard let viewModel = self.viewModel else { return }
        
        viewModel.rxImages
            .onMain()
            .subscribe(onNext: { [weak self] images in
                guard let `self` = self, !images.isEmpty else { return }
                self.isWatingLoadmore = false
                self.clvimages.reloadData()
            })
            .disposed(by: rxDisposeBag)
    }
}

extension GalleryVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        /** `Kéo đến bottom và đang k loading gì cả` */
        if (currentOffset >= maximumOffset) && (self.isWatingLoadmore == false) && (viewModel?.rxNextToken.value != nil) {
            self.isWatingLoadmore   = true
            viewModel?.fetchImage()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.rxImages.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryIconCell", for: indexPath) as! GalleryIconCell
        if let image = viewModel?.rxImages.value[safe: indexPath.item] {
            cell.image.setImage(withUrL: image.imageDetail.thumbs.small)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gap = 2
        let numberOfCell = 5
        let displayWidth = collectionView.frame.width - CGFloat((numberOfCell - 1) * gap)
        let cellWid = displayWidth / CGFloat(numberOfCell)
        return CGSize(width: cellWid, height: cellWid)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailImageVC = DetailImageVC()
        if let image = viewModel?.rxImages.value[safe: indexPath.item] {
            detailImageVC.imageURL = image.imageDetail.fullURL
        }
        push(vc: detailImageVC)
    }
}

import SDWebImage
extension UIImageView {
    public func setImage(withUrL url: String?) {
        guard let URL = URL(string: url ?? "") else { return }
        sd_setImage(with: URL, placeholderImage: UIImage(named: "images"))
    }
}
