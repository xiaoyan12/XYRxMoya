//
//  Response+Json.swift
//  XYRxMoya
//
//  Created by IvorChao on 2021/6/9.
//

import UIKit
import RxSwift
import Moya
import HandyJSON

/// 请求数据data的数据格式
public enum ResponseDataFormat {
    /// model
    case object
    /// 数组model
    case array
    /// 字典
    case dict
    /// 数据格式 有两层data 取里面的一层 获取数组model
    case double_object
    /// 数据格式 有两层data 取里面的一层 获取model
    case double_array
}

extension ObservableType where Element == Response {
    public func mapModel<T: HandyJSON>(type: T.Type,data_type: ResponseDataFormat) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            if let model = response.mapModel(T.self, data_type: data_type){
                if model.code == 1 {
                    return Observable.just(model.data as! T)
                }
                let error = ResponseError.init(code: model.code, msg: model.msg, baseModel: model)
                return Observable.error(error)
            }else{
                let error = ResponseError.init(code: -999999999, msg: "映射模型失败", baseModel: nil)
                return Observable.error(error)
            }
        }
    }
    
    public func mapModels<T: HandyJSON>(type: T.Type,data_type: ResponseDataFormat) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            if let model = response.mapModel(T.self, data_type: data_type){
                if model.code == 1 {
                    return Observable.just(model.data as! [T])
                }
                let error = ResponseError.init(code: model.code, msg: model.msg, baseModel: model)
                return Observable.error(error)
            }else{
                let error = ResponseError.init(code: -999999999, msg: "映射模型数组失败", baseModel: nil)
                return Observable.error(error)
            }
        }
    }
}

/// json数据 转 模型
extension Response {
    
    // 映射一个模型
    func mapModel<T: HandyJSON>(_ type: T.Type , data_type: ResponseDataFormat) -> BaseModel? {
        do {
            //过滤成功地状态码响应
            _ = try self.filterSuccessfulStatusCodes()
            let dataString = try self.mapString()
            print("mapModels = \(dataString)")
            if let model = BaseModel.deserialize(from: dataString) {
                switch data_type {
                case .object:
                    if let data = model.data as? Dictionary<String, Any>{
                        model.data = JSONDeserializer<T>.deserializeFrom(dict:data)
                    }else {
                        model.data = JSONDeserializer<T>.deserializeFrom(dict:[:])
                    }
                case .array:
                    if let data = model.data as? [Any] {
                        model.data = JSONDeserializer<T>.deserializeModelArrayFrom(array: data)
                    }else {
                        model.data = JSONDeserializer<T>.deserializeModelArrayFrom(array: [])
                    }
                case .dict:
                    if let data = model.data as? Dictionary<String, Any>{
                        model.data = data
                    }else {
                        model.data = [:]
                    }
                case .double_array:
                    if let data = model.data as? Dictionary<String, Any>{
                        if let data_array = data["data"] as? [Any]  {
                            model.data = JSONDeserializer<T>.deserializeModelArrayFrom(array: data_array)
                        }else {
                            model.data = JSONDeserializer<T>.deserializeModelArrayFrom(array: [])
                        }
                    }else {
                        model.data = JSONDeserializer<T>.deserializeModelArrayFrom(array: [])
                    }
                    
                case .double_object:
                    if let data = model.data as? Dictionary<String, Any>{
                        if let data_dict = data["data"] as? Dictionary<String, Any> {
                            model.data = JSONDeserializer<T>.deserializeFrom(dict:data_dict)
                        }else{
                            model.data = JSONDeserializer<T>.deserializeFrom(dict:[:])
                        }
                    }else {
                        model.data = JSONDeserializer<T>.deserializeFrom(dict:[:])
                    }
                }
                return model
            }
            return nil
            
        } catch let error {
            print("error = \(error)")
            //处理错误的状态码
            return JSONDeserializer<BaseModel>.deserializeFrom(dict:["code":-999999999,"msg":error.localizedDescription])
        }
    }
    
}


/// 请求错误信息
struct ResponseError : Error{
    
    /// 错误码
    var code: Int?
    
    /// 错误信息
    var msg: String?
    
    /// 接口原始数据 解析出的model
    var baseModel: BaseModel?
    
}


