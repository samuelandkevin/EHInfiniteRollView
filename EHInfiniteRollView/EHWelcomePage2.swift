//
//  EHWelcomePage2.swift
//  EasyAtHome
//
//  Created by 黄坤鹏 on 2020/6/24.
//  Copyright © 2020 Easy Healthcare Corporation. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class EHWelcomePage2 : EHWelcomePageBase {
    
    ///背景
    fileprivate lazy var imgvBG: UIImageView = {
        let imgvBG = UIImageView()
        imgvBG.image = UIImage(named: "startpage_pic_pg")
        return imgvBG
    }()
    
    fileprivate lazy var lbT: UILabel = {
        //Intelligent test reading and smart charting for proven and unsurpassed accuracy.
        let lbT = UILabel.eh_creatLabel(text: "Intelligent test reading and smart charting for proven and unsurpassed accuracy.", textAlignment:.center, textColor: "#383838".color, font: .systemFont(ofSize: fontAdapt(26), weight: .bold))
        lbT.numberOfLines = 0
        return lbT
    }()
    
    fileprivate lazy var imgv1: UIImageView = {
        let imgv1 = UIImageView()
        imgv1.image = UIImage(named: "2-peak")
        return imgv1
    }()
    
    fileprivate lazy var imgv2: UIImageView = {
        let imgv2 = UIImageView()
        imgv2.image = UIImage(named: "2_pic")
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
extension  EHWelcomePage2 {
    fileprivate func _setupUI(){
        addSubview(imgvBG)
        addSubview(imgv1)
        addSubview(imgv2)
        addSubview(lbT)
    }
    
    fileprivate func _layoutUI(){
        imgvBG.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        let imgv1H:CGFloat = imageHAdapt(387)
        let imgv1W:CGFloat = imgv1H*375.0/387
        
        imgv1.snp_makeConstraints { (make) in
            make.bottom.equalTo(imgv2.snp.top).offset(edgeAdapt(12))
            make.width.equalTo(imgv1W)
            make.height.equalTo(imgv1H)
            make.centerX.equalTo(self)
        }
        imgv2.snp_makeConstraints { (make) in
            make.height.equalTo(needScale ?kScreenHeight*343.0/designH : 363)
            make.left.right.bottom.equalTo(self)
        }
        lbT.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(edgeAdapt(20))
            make.right.equalTo(self).offset(-edgeAdapt(20))
            make.top.equalTo(imgv2).offset(edgeAdapt(70))
        }
    }
    
    fileprivate func _bind(){
        
    }
}

// MARK: - Public
extension EHWelcomePage2 {
    
}

// MARK: - Action
extension EHWelcomePage2 {
    @objc fileprivate func onButton(){
        
    }
}
