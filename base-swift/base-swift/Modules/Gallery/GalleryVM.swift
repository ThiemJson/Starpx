//
//  GalleryVM.swift
//  base-swift
//
//  Created by ThiemNC on 25/05/2024.
//  Copyright © 2024 BaseSwift. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/** `Define` */
protocol GalleryVM : BaseViewModel {
    var rxImages: BehaviorRelay<[ImageModel]> { get }
    var rxError: BehaviorRelay<BaseResponse?> { get }
}

/** `Implement function` */
extension GalleryVM {
    public func fetchImage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            rxImages.accept([ImageModel(), ImageModel(), ImageModel(), ImageModel()])
        }
    }
}

/** `Implement Properties` */
class GalleryVMObject : BaseViewModelObject, GalleryVM {
    var rxImages = RxRelay.BehaviorRelay<[ImageModel]>.init(value: [])
    var rxError = RxRelay.BehaviorRelay<BaseResponse?>.init(value: nil)
}
