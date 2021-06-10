//
//  BaseModel.swift
//  XYRxMoya
//
//  Created by IvorChao on 2021/6/9.
//

import UIKit
import HandyJSON

class BaseModel: HandyJSON {
    
    /// 错误码
    var code: Int?
    
    /// 请求提示
    var msg: String?
    
    /// data 数据
    var data: Any?
    
    /// 状态
    var status: Any?
    
    required init() {}
}
