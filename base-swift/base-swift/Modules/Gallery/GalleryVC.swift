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

class GalleryVC: BaseViewModelController<GalleryVM> {
    @IBOutlet weak var clvimages: UICollectionView!
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
                guard let `self` = self else { return }
                self.clvimages.reloadData()
            })
            .disposed(by: rxDisposeBag)
    }
}

extension GalleryVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100 //viewModel?.rxImages.value.count ?? 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryIconCell", for: indexPath) as! GalleryIconCell
        cell.image.setImage(withUrL: "https://picsum.photos/200")
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
        detailImageVC.imageURL = "https://picsum.photos/200"
        push(vc: detailImageVC)
    }
}

import SDWebImage
extension UIImageView {
    public func setImage(withUrL url: String?) {
        guard let URL = URL(string: url ?? "") else { return }
        sd_setImage(with: URL)
    }
}
