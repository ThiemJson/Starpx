//
//  DemoLoginVM.swift
//  base-swift
//
//  Created by ThiemJason on 4/25/23.
//  Copyright © 2023 BaseSwift. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol DemoLoginVM : BaseViewModel {
    var rxAuthModel: BehaviorRelay<BaseAuthModel?> { get }
    var rxError: BehaviorRelay<BaseResponse?> { get }
    func login(loginModel: BaseLoginModel)
}

extension DemoLoginVM {
    func login(loginModel: BaseLoginModel) {
        self.rxLoading.accept(true)
        let user = loginModel.email ?? Constant.username
        let pass = loginModel.password ?? Constant.password
        
        AWSManager.shared.login(username: user, password: pass) { response in
            self.rxLoading.accept(false)
            switch response {
                case .success(let session):
                    var authModel = BaseAuthModel()
                    authModel.name = session.idToken?.tokenString
                    authModel.token = session.accessToken?.tokenString
                    self.rxAuthModel.accept(authModel)
                case .failure(let _error):
                    let error = BaseResponse()
                    error.message = _error.localizedDescription
                    error.code = _error.asAFError?.responseCode
                    self.rxError.accept(error)
            }
        }
    }
}

class DemoLoginVMObject : BaseViewModelObject, DemoLoginVM {
    var rxAuthModel = RxRelay.BehaviorRelay<BaseAuthModel?>.init(value: nil)
    var rxError = RxRelay.BehaviorRelay<BaseResponse?>.init(value: nil)
}
