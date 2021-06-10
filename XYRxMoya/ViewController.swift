//
//  ViewController.swift
//  XYRxMoya
//
//  Created by IvorChao on 2021/6/9.
//

import UIKit
import RxSwift
import HandyJSON

class ViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NetworkManager.getLoginRequest(params: [:]) { isSucc, model, err in
            if isSucc {
//                model?.uid
            }else {
                if err?.code == -1 {
                    //拿到原始数据 处理逻辑 需要解析model
                    if let data = err?.baseModel?.data as? Dictionary<String, Any> {
                        let model = LoginModel.deserialize(from: data)
                        model?.uid
                    }
                }else if err?.code == -3 {
                    //弹出充值框
                }
            }
        }
        
        Observable.zip(
            NetworkManager.getLoginRequest(params: [:]),
            NetworkManager.getLoginRequest(params: [:])
        ).subscribe(onNext: { (arg0, arg1) in
            
        }).disposed(by: disposeBag)
        
        
        NetworkManager.getLoginRequest(params: [:]).subscribe(onNext: { (isSucc, model, err) in
            if isSucc {
//                model?.uid
            }else {
                if err?.code == 1 {
                    
                }
            }
        }).disposed(by: disposeBag)
        
        
    }
}

