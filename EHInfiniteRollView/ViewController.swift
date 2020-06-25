//
//  ViewController.swift
//  EHInfiniteRollView
//
//  Created by 黄坤鹏 on 2020/6/25.
//  Copyright © 2020 黄坤鹏. All rights reserved.
//

import UIKit
import SnapKit



class ViewController: UIViewController {

    ///轮播图
//    fileprivate lazy var cycleView: ZCycleView = {
//        let cycleView = ZCycleView(frame: view.bounds)
//        return cycleView
//    }()
    
    ///无限轮播
    fileprivate lazy var scrollV: EHWelcomeCollectionView = {
        let rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        let scrollV = EHWelcomeCollectionView(frame: rect)
        return scrollV
    }()
    
    
    fileprivate lazy var btnLogin: UIButton = {
        let btnLogin = UIButton.eh_create(title: "Login", backgroundColor: .white, font: UIFont.systemFont(ofSize: EHScale_Value(18), weight: .bold), titleColor: "#9E3CF8".color, imageName: nil, textAlignment: .center)
        btnLogin.layer.cornerRadius = 7
        btnLogin.layer.masksToBounds = true
        btnLogin.layer.borderColor = "#9E3CF8".color.cgColor
        btnLogin.layer.borderWidth = 1
        btnLogin.addTarget(self, action: #selector(onbtnLogin), for: .touchUpInside)
        return btnLogin
    }()
    
    fileprivate lazy var btnSignUp: UIButton = {
        let btnSignUp = UIButton.eh_create(title: "Sign Up", backgroundColor: "#9E3CF8".color, font: UIFont.systemFont(ofSize: EHScale_Value(18), weight: .bold), titleColor: .white, imageName: nil, textAlignment: .center)
        btnSignUp.layer.cornerRadius = 7
        btnSignUp.layer.masksToBounds = true
        btnSignUp.addTarget(self, action: #selector(onbtnSignUp), for: .touchUpInside)
        return btnSignUp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        navigationController?.isNavigationBarHidden = true

        
        view.addSubview(scrollV)
        scrollV.snp_makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        view.addSubview(btnLogin)
        view.addSubview(btnSignUp)
        btnLogin.snp_makeConstraints { (make) in
            make.left.equalTo(view).offset(25)
            make.right.equalTo(view.snp.centerX).offset(-5)
            make.height.equalTo(EHScale_Value(46))
            make.bottom.equalTo(view).offset(-EHScale_Value(35))
        }
        
        btnSignUp.snp_makeConstraints { (make) in
            make.right.equalTo(view).offset(-25)
            make.left.equalTo(view.snp.centerX).offset(5)
            make.height.equalTo(btnLogin)
            make.centerY.equalTo(btnLogin)
        }
        
    }
    
    // MARK: - Action
    @objc func onbtnLogin(){
      
    }
    
    @objc func onbtnSignUp(){
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupUI() {
       
    }
    
    @objc
    fileprivate func pushLoginVC() {
    }
    
    @objc
    fileprivate func pushRegisterVC() {
    }
    
    deinit {
        scrollV.stopTimer()
    }
}




