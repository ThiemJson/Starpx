//
//  ImageService.swift
//  base-swift
//
//  Created by ThiemNC on 25/05/2024.
//  Copyright © 2024 BaseSwift. All rights reserved.
//

import Foundation

public class ImageService {
    static func getImageSetSummaries(customerId: String, limit: Int, nextToken: String?) -> BaseResult<GetImageSetResponse> {
        return BaseRouter.images(customerId: customerId, limit: limit, nextToken: nextToken).object()
    }
}
