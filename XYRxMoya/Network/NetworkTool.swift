//
//  NetworkTool.swift
//  XYRxMoya
//
//  Created by IvorChao on 2021/6/9.
//

import UIKit
import Moya

let NetworkProvider = MoyaProvider<NetworkTool>()

/// 定义枚举
public enum NetworkTool {
    /// 网络请求
    case getNetWorkRequest(api: String?,params: Dictionary<String, Any>?,path:String)
}


extension NetworkTool: TargetType {

    /// 域名
    public var baseURL: URL {
        switch self {
        case .getNetWorkRequest(let api, _ , _):
            return URL(string: api ?? "http://www.baidu.com")!
        }
    }
    
    /// 请求的接口的地址
    public var path: String {
        
        switch self {
        case .getNetWorkRequest(_, _ , let path):
            return path
        }
    }
    
    /// 请求方式
    public var method: Moya.Method {
        return .post
    }
    
    /// 请求的任务事件
    public var task: Task {
        switch self {
        case .getNetWorkRequest(_, let params, _):
            return .requestParameters(parameters: params ?? [:], encoding: JSONEncoding.default)
        }
    }
    
    /// 这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var headers: [String : String]? {
        let params = Dictionary<String, String>()
        
        return params
    }
}
