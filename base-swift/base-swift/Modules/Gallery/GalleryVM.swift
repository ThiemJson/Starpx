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
    var rxImages: BehaviorRelay<[ImageSet]> { get }
    var rxError: BehaviorRelay<BaseResponse?> { get }
    var rxNextToken: BehaviorRelay<String?> { get }
}

/** `Implement function` */
extension GalleryVM {
    public func fetchImage() {
        let nextToken = rxNextToken.value == "Init" ? nil : rxNextToken.value
        self.rxLoading.accept(true)
        ImageService.getImageSetSummaries(customerId: "aabb1234", limit: 50, nextToken: nextToken)
            .onCompleted {
                self.rxLoading.accept(false)
            }
            .onSuccess { response in
                let data = response.data
                
                var images = rxImages.value
                images.append(contentsOf: data.getImageSetSummaries.imageSets)
                rxImages.accept(images)
                
                self.rxNextToken.accept(data.getImageSetSummaries.nextToken)
            }
            .onError { error in
                self.rxError.accept(error)
            }
    }
}

/** `Implement Properties` */
class GalleryVMObject : BaseViewModelObject, GalleryVM {
    var rxImages = RxRelay.BehaviorRelay<[ImageSet]>.init(value: [])
    var rxNextToken = RxRelay.BehaviorRelay<String?>.init(value: "Init")
    var rxError = RxRelay.BehaviorRelay<BaseResponse?>.init(value: nil)
}
