//
//  BaseRequest.swift
//  XYRxMoya
//
//  Created by IvorChao on 2021/6/10.
//

import UIKit
import HandyJSON
import RxSwift

class BaseRequest: NSObject {
    /// 声明垃圾袋
    private let disposeBag = DisposeBag()
    
    /// 声明结果回调
    /// - Parameters:
    ///   - isSuccess: 请求是否成功 只有当code=1时为true, 其他的为false 需要特殊处理的，取error里的值
    ///   - resultModel: isSuccess=true 是，返回数据
    ///   - error: 错误信息
    typealias resultBack<T> = (_ isSuccess: Bool, _ resultModel: T?, _ error: ResponseError?) -> Void
    
    /// 请求的方法
    /// - Parameters:
    ///   - api: 域名
    ///   - path: 链接
    ///   - params: 参数
    ///   - data_type: 数据格式
    ///   - class_type: 数据转换的model
    ///   - result: 返回的结果
    static func getNetworkRequest<T:HandyJSON>(api: String?,
                                               path: String,
                                               params: Dictionary<String, Any>?,
                                               data_type: ResponseDataFormat,
                                               class_type: T.Type,
                                               result: @escaping resultBack<Any>){
        BaseRequest().request(api: api, path: path, params: params, data_type: data_type, class_type: class_type) { isSuccess, model, error in
            result(isSuccess ,model , error)
        }
    }
    
}

extension BaseRequest {
    
    /// 请求
    /// - Parameters:
    ///   - api: 域名
    ///   - path: 链接
    ///   - params: 参数
    ///   - data_type: 数据格式
    ///   - class_type: 数据转换的model
    ///   - result: 返回的结果
    private func request<T: HandyJSON>(api: String?,
                                       path: String,
                                       params: Dictionary<String, Any>?,
                                       data_type: ResponseDataFormat,
                                       class_type: T.Type,
                                       result: @escaping resultBack<Any>){
        if data_type == .array || data_type == .double_array {
            NetworkProvider.rx.request(.getNetWorkRequest(api: api, params: params, path: path))
                .asObservable()
                .mapModels(type: T.self, data_type: data_type)
                .subscribe(onNext: { modelArray in
                    result(true,modelArray,nil)
                }, onError: { error in
                    if let responseError = error as? ResponseError {
                        result(false,nil,responseError)
                    }else {
                        var errMsg = ""
                        switch error.localizedDescription{
                            case "The request timed out.":
                                errMsg = "请求超时，请稍后再试"
                            case "The data couldn’t be read because it isn’t in the correct format.":
                                errMsg = "数据无法读取,不是正确的格式。"
                            case "The Internet connection appears to be offline.":
                                errMsg = "网络断开，请检查您的网络连接"
                            case "The network connection was lost.":
                                errMsg = "网络连接错误"
                            case "Could not connect to the server.":
                                errMsg = "无法连接到服务器。"
                            default:
                                errMsg = error.localizedDescription
                        }
                        result(false,nil,ResponseError(code: -9999999999, msg: errMsg, baseModel: nil))
                    }
                }, onCompleted: {
                    
                }, onDisposed:{
                    
                }).disposed(by: disposeBag)
        }else {
            NetworkProvider.rx.request(.getNetWorkRequest(api: api, params: params, path: path))
                .asObservable()
                .mapModel(type: T.self, data_type: data_type)
                .subscribe(onNext: { model in
                    result(true,model,nil)
                }, onError: { error in
                    if let responseError = error as? ResponseError {
                        result(false,nil,responseError)
                    }else {
                        var errMsg = ""
                        switch error.localizedDescription{
                            case "The request timed out.":
                                errMsg = "请求超时，请稍后再试"
                            case "The data couldn’t be read because it isn’t in the correct format.":
                                errMsg = "数据无法读取,不是正确的格式。"
                            case "The Internet connection appears to be offline.":
                                errMsg = "网络断开，请检查您的网络连接"
                            case "The network connection was lost.":
                                errMsg = "网络连接错误"
                            case "Could not connect to the server.":
                                errMsg = "无法连接到服务器。"
                            default:
                                errMsg = error.localizedDescription
                        }
                        result(false,nil,ResponseError(code: -9999999999, msg: errMsg, baseModel: nil))
                    }
                }, onCompleted: {
                    
                }, onDisposed:{
                    
                }).disposed(by: disposeBag)
        }
        
    }
}
