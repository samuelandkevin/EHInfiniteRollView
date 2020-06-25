//
//  EHWelcomePage1.swift
//  EasyAtHome
//
//  Created by 黄坤鹏 on 2020/6/24.
//  Copyright © 2020 Easy Healthcare Corporation. All rights reserved.
//

import Foundation
import UIKit
class EHWelcomePageBase: UICollectionViewCell {
    
    /// 设计图高度
    let designH:CGFloat = 812
    
    /// 字体大小
    func fontAdapt(_ value:CGFloat) ->CGFloat{
        if kScreenHeight >= designH {
            return value
        }else{
            return kScreenHeight * value*1.0/designH
        }
    }
    
    /// 图片高度适配
    func imageHAdapt(_ value:CGFloat)->CGFloat{
        if kScreenHeight >= designH {
            return value
        }else{
            return kScreenHeight * value*1.0/designH
        }
    }
    
    /// 边距适配
    func edgeAdapt(_ value:CGFloat)->CGFloat{
        if kScreenHeight >= designH {
            return value
        }else{
            return kScreenHeight * value*1.0/designH
        }
    }
    
    /// 是否需要伸缩变化
    var needScale:Bool {
        // 设计图高度为812
        return kScreenHeight >= designH ? false : true
    }
}


class EHWelcomePage1 : EHWelcomePageBase {
  
    ///背景
    fileprivate lazy var imgvBG: UIImageView = {
        let imgvBG = UIImageView()
        imgvBG.image = UIImage(named: "startpage_pic_pg")
        return imgvBG
    }()
    
    fileprivate lazy var lbT: UILabel = {
        //What did users say about us?
        let lbT = UILabel.eh_creatLabel(text: "What did users say\nabout us?", textAlignment:.center, textColor: .white, font: .systemFont(ofSize: fontAdapt(30), weight: .bold))
        lbT.numberOfLines = 0
        return lbT
    }()
    
    fileprivate lazy var imgv1: UIImageView = {
        let imgv1 = UIImageView()
        imgv1.contentMode = .scaleAspectFit
        imgv1.image = UIImage(named: "1_pic_appraisal_01")
        return imgv1
    }()
    
    fileprivate lazy var imgv2: UIImageView = {
        let imgv2 = UIImageView()
        imgv2.contentMode = .scaleAspectFit
        imgv2.image = UIImage(named: "1_pic_appraisal_02")
        return imgv2
    }()
    
    fileprivate lazy var imgv3: UIImageView = {
        let imgv3 = UIImageView()
        imgv3.contentMode = .scaleAspectFit
        imgv3.image = UIImage(named: "1_pic_appraisal_03")
        return imgv3
    }()
    
    fileprivate lazy var imgv4: UIImageView = {
        let imgv4 = UIImageView()
        imgv4.contentMode = .scaleAspectFit
        imgv4.image = UIImage(named: "1_pic_appraisal_04")
        return imgv4
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
extension  EHWelcomePage1 {
    fileprivate func _setupUI(){
        addSubview(imgvBG)
        addSubview(lbT)
        addSubview(imgv1)
        addSubview(imgv2)
        addSubview(imgv3)
        addSubview(imgv4)
    }
    
    fileprivate func _layoutUI(){
        imgvBG.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        lbT.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
//            make.top.equalTo(self).offset(edgeAdapt(66))
        }
       
        let imgv1H:CGFloat = imageHAdapt(115)
        let imgv1W:CGFloat = imgv1H*300.0/115
        
        let imgv2H:CGFloat = imageHAdapt(115)
        let imgv2W:CGFloat = imgv2H*320.0/115
        
        let imgv3H:CGFloat = imageHAdapt(115)
        let imgv3W:CGFloat = imgv3H*300.0/115
        
        let imgv4H:CGFloat = imageHAdapt(115)
        let imgv4W:CGFloat = imgv4H*300.0/115
        
        imgv1.snp_makeConstraints { (make) in
           
            make.width.equalTo(imgv1W)
            make.height.equalTo(imgv1H)
            make.top.equalTo(lbT.snp.bottom).offset(edgeAdapt(15))
            make.right.equalTo(self)
        }
        imgv2.snp_makeConstraints { (make) in
            make.width.equalTo(imgv2W)
            make.height.equalTo(imgv2H)
            make.top.equalTo(imgv1.snp.bottom)
            make.left.equalTo(self).offset(edgeAdapt(10))
        }
        imgv3.snp_makeConstraints { (make) in
            make.width.equalTo(imgv3W)
            make.height.equalTo(imgv3H)
            make.top.equalTo(imgv2.snp.bottom)
            make.right.equalTo(self).offset(-edgeAdapt(20))
        }
        imgv4.snp_makeConstraints { (make) in
            make.width.equalTo(imgv4W)
            make.height.equalTo(imgv4H)
            make.top.equalTo(imgv3.snp.bottom)
            make.right.equalTo(self).offset(-edgeAdapt(55))
            make.bottom.equalTo(self).offset(-edgeAdapt(184))
        }
    }
    
    fileprivate func _bind(){
        
    }
}

// MARK: - Public
extension EHWelcomePage1 {
    
    func getSnapshotImage()->UIImage?{
        let layer = self.layer
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, true, 1);
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in:context)
        let screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshotImage
    }
    
}

// MARK: - Action
extension EHWelcomePage1 {
    @objc fileprivate func onButton(){
        
    }
}

