//
//  EHWelcomeCollectionView.swift
//  EasyAtHome
//
//  Created by 黄坤鹏 on 2020/6/25.
//  Copyright © 2020 Easy Healthcare Corporation. All rights reserved.
//

import Foundation
import UIKit

@objc protocol EHWelcomeCollectionViewDelegate:NSObjectProtocol {
    //点击代理方法
    @objc optional func EHWelcomeCollectionView(_ scrollView: EHWelcomeCollectionView, didSelectRowAt index: NSInteger)
}

fileprivate let collectionViewCellId = "collectionViewCellId"
class EHWelcomeCollectionView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource {
    
    //代理
    weak var EHWelcomeCollectionViewDelegate:EHWelcomeCollectionViewDelegate?
    
    //分页指示器页码颜色
    var pageControlColor:UIColor?
    
    //分页指示器当前页颜色
    var currentPageControlColor:UIColor?
    
    //分页指示器位置
    var pageControlPoint:CGPoint?
    
    //分页指示器
    /// pageControl
    lazy var pageControl:UIPageControl = {
        let pageControl = UIPageControl()
        return pageControl
    }()
    
    //自动滚动时间默认为3.0
    var autoScrollDelay:TimeInterval = 3 {
        didSet{
            stopTimer()
            startTimer()
        }
    }
    
   
    //设置图片资源url字符串。
    var imgUrls = NSArray(){
        didSet{
            pageControl.numberOfPages = imgUrls.count
            self.reloadData()
        }
    }
    
    fileprivate var itemCount:NSInteger?//cellNum
    fileprivate var timer:Timer?//定时器
    
    fileprivate lazy var v1: EHWelcomePage1 = {
        let v1 = EHWelcomePage1()
        return v1
    }()
    
    fileprivate lazy var v2: EHWelcomePage2 = {
        let v2 = EHWelcomePage2()
        return v2
    }()
    
    fileprivate lazy var v3: EHWelcomePage3 = {
        let v3 = EHWelcomePage3()
        return v3
    }()
    
    fileprivate lazy var v4: EHWelcomePage4 = {
        let v4 = EHWelcomePage4()
        return v4
    }()
    
    fileprivate lazy var v5: EHWelcomePage5 = {
        let v5 = EHWelcomePage5()
        return v5
    }()
    
    fileprivate lazy var v6: EHWelcomePage6 = {
        let v6 = EHWelcomePage6()
        return v6
    }()
    

    //便利构造方法
    convenience init(frame:CGRect) {
        self.init(frame: frame, collectionViewLayout: EHWelcomeFlowLayout.init())
    }

    convenience init(frame:CGRect,imageUrls:NSArray) {
        self.init(frame: frame, collectionViewLayout: EHWelcomeFlowLayout.init())
        imgUrls = imageUrls
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = UIColor.white
        self.dataSource = self
        self.delegate = self
        
        self.register(EHWelcomePage1.classForCoder(), forCellWithReuseIdentifier: "1")
        self.register(EHWelcomePage2.classForCoder(), forCellWithReuseIdentifier: "2")
        self.register(EHWelcomePage3.classForCoder(), forCellWithReuseIdentifier: "3")
        self.register(EHWelcomePage4.classForCoder(), forCellWithReuseIdentifier: "4")
        self.register(EHWelcomePage5.classForCoder(), forCellWithReuseIdentifier: "5")
        self.register(EHWelcomePage6.classForCoder(), forCellWithReuseIdentifier: "6")
        imgUrls = ["1","2","3","4","5","6"]

        startTimer()
        //在collectionView加载完成后默认滚动到索引为imgUrls.count的位置，这样cell就可以向左或右滚动
        DispatchQueue.main.async {
            //注意：在轮播器视图添加到控制器的view上以后，这样是为了将分页指示器添加到self.superview上(如果将分页指示器直接添加到collectionView上的话，指示器将不能正常显示)
            self.setUpPageControl()
            let indexpath = NSIndexPath.init(row: self.imgUrls.count, section: 0)
            //滚动位置
            self.scrollToItem(at: indexpath as IndexPath, at: .left, animated: false)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //itemNum 设置为图片数组的n倍数(n>1)，当未设置imgUrls时，随便返回一个数6
        return imgUrls.count > 0 ? imgUrls.count*1000 : 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        itemCount = self.numberOfItems(inSection: 0)
        
        if imgUrls.count > 0 {
            if let urlStr = self.imgUrls[indexPath.row % imgUrls.count] as? String {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier:urlStr , for: indexPath)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if imgUrls.count != 0 {
            EHWelcomeCollectionViewDelegate?.EHWelcomeCollectionView!(self, didSelectRowAt: indexPath.row % imgUrls.count)
        }else{
            print("图片数组为空！")
        }
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //当前的索引
        var offset:NSInteger = NSInteger(scrollView.contentOffset.x / scrollView.bounds.size.width)
        
        //第0页时，跳到索引imgUrls.count位置；最后一页时，跳到索引imgUrls.count-1位置
        if offset == 0 || offset == (self.numberOfItems(inSection: 0) - 1) {
            if offset == 0 {
                offset = imgUrls.count
            }else {
                offset = imgUrls.count - 1
            }
        }
        //跳转方式一：
        //        let indexpath = NSIndexPath.init(row: offset, section: 0)
        //        //滚动位置
        //        self.scrollToItem(at: indexpath as IndexPath, at: .left, animated: false)
        //跳转方式二：
        scrollView.contentOffset = CGPoint.init(x: CGFloat(offset) * scrollView.bounds.size.width, y: 0)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 设置分页指示器索引
        let currentPage:NSInteger = NSInteger(scrollView.contentOffset.x / scrollView.bounds.size.width)
        let currentPageIndex = imgUrls.count > 0 ? currentPage % imgUrls.count : 0
        self.pageControl.currentPage = currentPageIndex
        
//        if currentPageIndex == 5 {
//            pageControl.pageIndicatorTintColor =  "#E1C8FF".color
//            pageControl.currentPageIndicatorTintColor = "#9E3CF8".color
//        }else{
//            pageControl.pageIndicatorTintColor =  "#E1C8FF".color
//            pageControl.currentPageIndicatorTintColor = "#9E3CF8".color
//        }
    }
    
    //定时器滚动scrollview停止的时候，显示下一张图片
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    
    //MARK: - ACTIONS
    @objc private func setUpPageControl(){
    
        pageControl.pageIndicatorTintColor =  "#E1C8FF".color
        pageControl.currentPageIndicatorTintColor = "#9E3CF8".color
        pageControl.numberOfPages = imgUrls.count
        pageControl.currentPage = 0
        
        self.superview?.addSubview(pageControl)
        
        pageControl.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.width.equalTo(80)
            make.height.equalTo(20)
            //kun调试
            make.bottom.equalTo(kScreenHeight >= 812 ? -119 :  -kScreenHeight*119.0/812)
        }
        
    }
    //添加定时器
    @objc func startTimer(){
        timer = Timer(timeInterval: autoScrollDelay, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    //移除定时器
    @objc func stopTimer(){
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    //自动滚动
    @objc private func autoScroll(){
        //当前的索引
        var offset:NSInteger = NSInteger(self.contentOffset.x / self.bounds.size.width)
        
        //第0页时，跳到索引imgUrls.count位置；最后一页时，跳到索引imgUrls.count-1位置
        guard let itemCount = itemCount else {return}
        if offset == 0 || offset == (itemCount - 1) {
            if offset == 0 {
                offset = imgUrls.count
            }else {
                offset = imgUrls.count - 1
            }
            
            self.contentOffset = CGPoint.init(x: CGFloat(offset) * self.bounds.size.width, y: 0)
            //再滚到下一页
            self.setContentOffset(CGPoint.init(x: CGFloat(offset + 1) * self.bounds.size.width, y: 0), animated: true)
        }else{
            //直接滚到下一页
            self.setContentOffset(CGPoint.init(x: CGFloat(offset + 1) * self.bounds.size.width, y: 0), animated: true)
        }
    }

    
    deinit {
        #if DEBUG
        print("EHWelcomeCollectionView is deinit ")
        #endif
    }
}

//MARK: - 用CollectionViewFlowLayout布局cell
class EHWelcomeFlowLayout:UICollectionViewFlowLayout{
    //prepare方法在collectionView第一次布局的时候被调用
    override func prepare() {
        super.prepare()//必须写
        collectionView?.backgroundColor = UIColor.white
        //通过打印可以看到此时collectionView的frame就是我们前面设置的frame
        print("self.collectionView:\(String(describing: self.collectionView))")
        // 通过collectionView 的属性布局cell
        self.itemSize = (self.collectionView?.bounds.size)!
        self.minimumInteritemSpacing = 0 //cell之间最小间距
        self.minimumLineSpacing = 0 //最小行间距
        self.scrollDirection = .horizontal;
        
        self.collectionView?.bounces = false //禁用弹簧效果
        self.collectionView?.isPagingEnabled = true //分页
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.showsVerticalScrollIndicator = false
    }
}

