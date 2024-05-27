//
//  OHRouter.swift
//  BaseSwift
//
//  Created by ThiemJason on 24/03/2023.
//  Copyright © 2023 BaseSwift. All rights reserved.
//

import Alamofire
/**
 This API from https://www.appsloveworld.com/sample-rest-api-url-for-testing-with-authentication
 */
enum BaseEndpoint : String {
    /** `Auth` */
    case register   = "/authaccount/registration"
    case login      = "/authaccount/login"
    
    /** `User` */
    case user       = "/users"
    
    case images     = "graphql"
}

enum BaseRouter {
#if Develop
    static let domain  = "api-dev.starpx.com"
    static let baseURL = "https://\(domain)/graphql"
#elseif Staging
    static let domain  = "api-dev.starpx.com"
    static let baseURL = "https://\(domain)/graphql"
#else
    static let domain  = "api-dev.starpx.com"
    static let baseURL = "https://\(domain)"
#endif
    
    /** `Images` */
    case images(customerId: String, limit: Int, nextToken: String?)
}

extension BaseRouter: URLRequestConvertible {
    // MARK: - Request Info
    var request: (HTTPMethod, String) {
        switch self {
            case .images(customerId: _, limit: _, nextToken: _):
                return (.post, BaseEndpoint.images.rawValue)
        }
    }
    
    //MARK: - Request Params
    /**
     ******************************************************************
     * Config Query & Body
     ******************************************************************
     */
    var params: [String: Any]? {
        switch self {
                /** `Auth` */
            case .images(customerId: let customerId, limit: let limit, nextToken: let nextToken):
                var params: [String: Any] = [:]
                params["operationName"] = "getImageSetSummaries"
                params["query"] = "query getImageSetSummaries($customerId: String!, $limit: Int, $nextToken: String) {  getImageSetSummaries(    customerId: $customerId    limit: $limit    nextToken: $nextToken  ) {    nextToken    image_sets {      caption      set_id      state      image_detail {        full_height        full_url        full_width        thumbs {          xlarge          large          small          medium          __typename        }        __typename      }      __typename    }    __typename  }}"
                var variables: [String: Any] = ["customerId": customerId, "limit": limit]
                if let nextToken = nextToken {
                    variables.updateValue(nextToken, forKey: "nextToken")
                }
                params["variables"] = variables
                return params
        }
    }
}

// MARK: - Request Define
extension BaseRouter {
    func asURLRequest() throws -> URLRequest {
        let url = try BaseRouter.baseURL.asURL()
        let method = request.0
        let path = request.1
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        let jsonEncodingMethods: [HTTPMethod] = [.post, .put, .delete, .patch]
        let encoding: ParameterEncoding = jsonEncodingMethods.contains(method) ? JSONEncoding.default : URLEncoding.queryString
        urlRequest = try encoding.encode(urlRequest, with: params)
        return urlRequest
    }
}
