//
//  DetailImageVCViewController.swift
//  base-swift
//
//  Created by ThiemNC on 25/05/2024.
//  Copyright © 2024 BaseSwift. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailImageVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageShare: UIImageView!
    @IBOutlet weak var backward: UIImageView!
    private let disposeBag = DisposeBag()
    var imageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.setImage(withUrL: imageURL)
        
        imageShare.rx.tap().subscribe(onNext: { [weak self] _ in
            guard let `self` = self, let image = imageView.image else { return }
            // set up activity view controller
            let imageToShare = [ image ]
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ 
                UIActivity.ActivityType.airDrop, 
                UIActivity.ActivityType.postToFacebook
            ]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        backward.rx.tap().subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.pop(animated: true)
        }).disposed(by: disposeBag)
        
    }
}
