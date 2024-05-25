//
//  DemoDashboardVC.swift
//  base-swift
//
//  Created by ThiemJason on 25/04/2023.
//  Copyright © 2023 BaseSwift. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DemoDashboardVC: BaseViewModelController<DemoDashboardVM> {
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnGallery: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
    }
    
    override func handlerAction() {
        super.handlerAction()
        self.btnLogout.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                
                /** `Delete token`  */
                UserDefaultUtils.shared.removeAccessToken()
                
                /** `Navigate to Login` */
                let loginVC = DemoLoginVC(DemoLoginVMObject())
                self.replaceRoot(to: loginVC, withTransitionType: .moveIn , andTransitionSubtype: .fromLeft)
            })
            .disposed(by: self.rxDisposeBag)
        
        
        self.btnGallery.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                let galleryVC = GalleryVC(GalleryVMObject())
                self.push(vc: galleryVC)
            })
            .disposed(by: self.rxDisposeBag)
    }
}
