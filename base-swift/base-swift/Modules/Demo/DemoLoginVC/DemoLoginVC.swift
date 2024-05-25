//
//  DemoLoginVC.swift
//  base-swift
//
//  Created by ThiemJason on 25/04/2023.
//  Copyright © 2023 BaseSwift. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DemoLoginVC: BaseViewModelController<DemoLoginVM> {
    @IBOutlet weak var tfUserName       : UITextField!
    @IBOutlet weak var tfPass           : UITextField!
    @IBOutlet weak var btnLogin         : UIButton!
    
    private let defaultUser = "hendrik@starpx.com"
    private let defaultPass = "StarpxStarpx1!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func handlerAction() {
        super.handlerAction()
        self.btnLogin.rx
            .tapWithNetwork()
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                var loginModel      = BaseLoginModel()
                loginModel.email    = self.tfUserName.text ?? defaultUser
                loginModel.password = "\(self.tfPass.text ?? defaultPass)"//.enCryptoData()
                self.viewModel?.login(loginModel: loginModel)
            })
            .disposed(by: self.rxDisposeBag)
    }
    
    override func setupBinding() {
        super.setupBinding()
        guard let viewModel = self.viewModel else { return }
        
        viewModel.rxAuthModel
            .asDriver()
            .compactMap { $0 }
            .drive(onNext: { [weak self] (authModel) in
                guard
                    let `self`  = self,
                    let token   = authModel.token,
                    token.isEmpty == false
                else { return }
                
                /** `Save local` */
                UserDefaultUtils.shared.saveAccessToken(token: token)
                
                /** `Change root to Dashboard` */
                self.replaceRoot(to: DemoDashboardVC(DemoDashboardVMObject()))
            })
            .disposed(by: self.rxDisposeBag)
        
        viewModel.rxError
            .asDriver()
            .compactMap { $0 }
            .drive(onNext: { [weak self] (response) in
                guard
                    let `self`  = self,
                    let code    = response.code,
                    let msg     = response.message
                else { return }
                self.showSnackError(message: "Error: \(code) \(msg)")
            })
            .disposed(by: self.rxDisposeBag)
    }
}
