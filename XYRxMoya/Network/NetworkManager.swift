//
//  NetworkManager.swift
//  XYRxMoya
//
//  Created by IvorChao on 2021/6/10.
//

import UIKit
import RxSwift

class NetworkManager: NSObject {
    
    
    static func getLoginRequest(params: Dictionary<String, Any>,result: @escaping (_ isSuccess: Bool, _ resultModel: LoginModel?, _ error: ResponseError?) -> Void) {
        BaseRequest.getNetworkRequest(api: nil, path: "", params: params, data_type: .object, class_type: LoginModel.self) { isSucc, model, error in
            result(isSucc,model as? LoginModel,error)
        }
    }
    

    static func getLoginRequest(params: Dictionary<String, Any>) -> Observable<(Bool,LoginModel?,ResponseError?)> {
        return Observable.create { event in
            BaseRequest.getNetworkRequest(api: nil, path: "", params: params, data_type: .object, class_type: LoginModel.self) { isSucc, model, error in
                event.onNext((isSucc, model as? LoginModel, error))
                event.onCompleted()
            }
            return Disposables.create()
        }
        
    }
    
    
}

