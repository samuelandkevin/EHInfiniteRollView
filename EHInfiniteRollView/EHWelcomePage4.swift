//
//  EHWelcomePage4.swift
//  EasyAtHome
//
//  Created by 黄坤鹏 on 2020/6/24.
//  Copyright © 2020 Easy Healthcare Corporation. All rights reserved.
//

import Foundation
import UIKit
class EHWelcomePage4 : EHWelcomePageBase {
    
    
    ///背景
    fileprivate lazy var imgvBG: UIImageView = {
        let imgvBG = UIImageView()
        imgvBG.image = UIImage(named: "startpage_pic_pg")
        return imgvBG
    }()
    
    fileprivate lazy var lbT1: UILabel = {
        //Find Your Fertile Window
        let lbT1 = UILabel.eh_creatLabel(text: "Find Your Fertile Window", textAlignment:.center, textColor: .white, font: .systemFont(ofSize: fontAdapt(30), weight: .bold))
        lbT1.numberOfLines = 0
        return lbT1
    }()
    
    fileprivate lazy var lbT2: UILabel = {
        //User Friendly Logging.
        let lbT2 = UILabel.eh_creatLabel(text: "User Friendly Logging.", textAlignment:.center, textColor: "#383838".color, font: .systemFont(ofSize: fontAdapt(26), weight: .bold))
        lbT2.numberOfLines = 0
        return lbT2
    }()
    
    fileprivate lazy var imgv1: UIImageView = {
        let imgv1 = UIImageView()
        imgv1.image = UIImage(named: "4-calendar")
        return imgv1
    }()
    
    fileprivate lazy var imgv2: UIImageView = {
        let imgv2 = UIImageView()
        imgv2.image = UIImage(named: "4_pic")
        return imgv2
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setupUI()
        _layoutUI()
        _bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
extension  EHWelcomePage4 {
    fileprivate func _setupUI(){
        addSubview(imgvBG)
        addSubview(imgv1)
        addSubview(imgv2)
        addSubview(lbT1)
        addSubview(lbT2)
    }
    
    fileprivate func _layoutUI(){
        imgvBG.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
//        let imgv1H:CGFloat = imageHAdapt(364)
//        let imgv1W:CGFloat = imgv1H*333.0/364
        
        let imgv1W:CGFloat = kScreenWidth-EHScale_Value(42)
        let imgv1H:CGFloat = 364.0/333*imgv1W
        
        imgv1.snp_makeConstraints { (make) in
//            make.bottom.equalTo(imgv2.snp.top).offset(edgeAdapt(75))
            make.bottom.equalTo(imgv2.snp.top).offset(75.0/375*imgv1W)
            make.width.equalTo(imgv1W)
            make.height.equalTo(imgv1H)
            make.centerX.equalTo(self)
        }
        imgv2.snp_makeConstraints { (make) in
            make.height.equalTo(needScale ?kScreenHeight*360.0/812 : 380)
            make.left.right.bottom.equalTo(self)
        }
        lbT1.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(imgv1.snp.top).offset(-edgeAdapt(15))
        }
        lbT2.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(edgeAdapt(20))
            make.right.equalTo(self).offset(-edgeAdapt(20))
            make.top.equalTo(imgv2).offset(edgeAdapt(86))
        }
    }
    
    fileprivate func _bind(){
        
    }
}

// MARK: - Public
extension EHWelcomePage4 {
    
}

// MARK: - Action
extension EHWelcomePage4 {
    @objc fileprivate func onButton(){
        
    }
}
