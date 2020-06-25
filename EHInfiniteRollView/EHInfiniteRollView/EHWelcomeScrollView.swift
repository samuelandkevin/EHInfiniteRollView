//
//  EHWelcomeScrollView.swift
//  EasyAtHome
//
//  Created by 黄坤鹏 on 2020/6/24.
//  Copyright © 2020 Easy Healthcare Corporation. All rights reserved.
//  欢迎页滚动视图

import Foundation
import UIKit

protocol EHWelcomeScrollViewDelegate: class {
    /// 点击第几个
    func scrollView(_ scrollView:EHWelcomeScrollView,didSelectIndex:Int)
    /// 显示下一个
    func displayNext(_scrollView:EHWelcomeScrollView)
    
}


class EHWelcomeScrollView : UIView {
    
    // MARK: - 公有属性
    /// 内容视图
    var arrImages:[UIImage]

    /// 是否竖屏显示scrollview，默认是no
    var isScrollDirectionPortrait:Bool = false
    /// pageControl
    lazy var pageControl:UIPageControl = {
        let pageControl = UIPageControl()
        return pageControl
    }()
    /// 隐藏pageControl
    var hidePageControl:Bool = false {
        didSet{
            self.pageControl.isHidden = hidePageControl
        }
    }
    /// 定时器时间间距
    var timerInterval:Int = 3
    /// 是否可以手动滑动
    var scrollEnabled:Bool = false
    /// 代理
    weak var delegate:EHWelcomeScrollViewDelegate?
    
    
    // MARK: - 私用属性
    /// 无限滚动图片数量
    fileprivate let ImageViewCount:Int = 3
    /// 滚动视图
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator   = false
        scrollView.isPagingEnabled = true
        scrollView.bounces  = false
        scrollView.delegate = self
        return scrollView
    }()
    
    fileprivate var timer:Timer?
    
    fileprivate lazy var isFirstLoad: Bool = false
    
    init(images:[UIImage]){
        self.arrImages = images
        super.init(frame: .zero)
        
        _setupUI()
        _layoutUI()
        _bind()
        
        // 设置页码
        self.pageControl.numberOfPages = arrImages.count;
        self.pageControl.currentPage   = 0;
        
        // 设置内容
        displayImage()
        
        // 开始定时器
        startTimer()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addTap()
        scrollView.isScrollEnabled = scrollEnabled
        
        if isScrollDirectionPortrait { //竖向滚动
            self.scrollView.contentSize = CGSize(width: 0, height: CGFloat(ImageViewCount) * self.bounds.size.height)
        }else{
            self.scrollView.contentSize = CGSize(width: CGFloat(ImageViewCount) * self.bounds.size.height, height:0 )
        }
        
        for i in 0..<ImageViewCount {
            if i < self.scrollView.subviews.count {
                let v = self.scrollView.subviews[i]
                if (self.isScrollDirectionPortrait) {//竖向滚动时imageview的frame

                    v.frame = CGRect(x: 0, y: CGFloat(i) * self.scrollView.frame.size.height, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height)

                } else {//横向滚动时imageview的frame

                    v.frame = CGRect(x: CGFloat(i) * self.scrollView.frame.size.width, y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height)
                }
            }
            
        }
        
       
        
    }
    
    fileprivate func addTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCallback))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
        
    }
    
    deinit {
        #if DEBUG
        print("EHInfiniteRollScrollView is deinit ")
        #endif
    }
    
}

// MARK: - Private
extension EHWelcomeScrollView  {
    fileprivate func _setupUI(){
        // 滚动视图
        self.addSubview(scrollView)
        
        // 控件
        for _ in 0..<ImageViewCount {
            let v = UIImageView()
            scrollView.addSubview(v)
        }
        
        // 页码视图
        self.addSubview(pageControl)
    }
    
    fileprivate func _layoutUI(){
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        pageControl.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.width.equalTo(80)
            make.height.equalTo(20)
            //kun调试
            make.bottom.equalTo(-EHScale_Value(110))
        }
        
    }
    
    fileprivate func _bind(){
        
    }
}

// MARK: - Public
extension EHWelcomeScrollView {
    /// 停止定时器
    func stopTimer(){
        if self.timer != nil {
            self.timer!.invalidate()
            //需要手动设置timer为nil，因为定时器被系统强引用了，必须手动释放
            self.timer = nil
        }
    }
    
    ///启动定时器
    func startTimer(){
        if arrImages.count > 1 {
            
            stopTimer()
            self.timer?.invalidate()
            self.timer = nil
            let timer = Timer(timeInterval: TimeInterval(self.timerInterval), target: self, selector: #selector(displayNextImage), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: .commonModes)
            self.timer = timer
            
        }else{
            stopTimer()
        }
        
    }
}

// MARK: - Action
extension EHWelcomeScrollView {
    
    @objc fileprivate func tapCallback(){
        self.delegate?.scrollView(self, didSelectIndex: self.pageControl.currentPage)
    }
}

// MARK: - Action
extension EHWelcomeScrollView :UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 当两张图片同时显示在屏幕中，找出占屏幕比例超过一半的那张图片
        var page:Int = 0
        var minDistance:CGFloat = CGFloat(MAXFLOAT)
        for i in 0..<self.scrollView.subviews.count {
            let v = self.scrollView.subviews[i]
            var distance:CGFloat = 0
            if (self.isScrollDirectionPortrait) {
                distance = fabs(v.frame.origin.y - scrollView.contentOffset.y)
            } else {
                distance = fabs(v.frame.origin.x - scrollView.contentOffset.x)
            }
            
            if (distance < minDistance) {
                minDistance = distance
                page = v.tag
            }
        }
        self.pageControl.currentPage = page
        
    }
    
    //用手开始拖拽的时候，就停止定时器，不然用户拖拽的时候，也会出现换页的情况
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    //用户停止拖拽的时候，就启动定时器
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
    
    //手指拖动scroll停止的时候，显示下一张图片
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        displayImage()
    }
    
    //定时器滚动scrollview停止的时候，显示下一张图片
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        displayImage()
    }
    
    
    
    
    @objc func displayImage(){
        
        // 设置图片，三个控件无限显示
        for i in 0..<ImageViewCount {
            if i < self.scrollView.subviews.count {
                let imgv = self.scrollView.subviews[i] as! UIImageView
                imgv.alpha         = 1
                var index = self.pageControl.currentPage
                
                /**
                 *  滚到第一张，并且是程序刚启动是第一次加载图片，index才减一。
                 加上这个判断条件，是为了防止当程序第一次加载图片时，此时第一张图片的i=0，那么此时index--导致index<0，进入下面index<0的判断条件，让第一个imageview显示的是最后一张图片
                 */
                if i == 0 ,self.isFirstLoad == true {
                    index -= 1
                }else if i == 2 {//滚到最后一张图片，index加1
                    index += 1
                }
                
                if index < 0 {//如果滚到第一张还继续向前滚，那么就显示最后一张
                    index = self.pageControl.numberOfPages-1
                }else if index >= self.pageControl.numberOfPages {//滚动到最后一张的时候，由于index加了一，导致index大于总的图片个数，此时把index重置为0，所以此时滚动到最后再继续向后滚动就显示第一张图片了
                    index = 0
                }
                
                imgv.tag = index
                if  index < arrImages.count{
                    let image = arrImages[index]
                    imgv.image = image
                }
            }
            
            
        }
        
        
        self.isFirstLoad = true
        
        // 偏移一个scrollview的高度或者宽度，让scrollview显示中间的imageview
        if self.isScrollDirectionPortrait {
            self.scrollView.contentOffset = CGPoint(x: 0, y: self.scrollView.frame.size.height)
        } else {
            self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width, y: 0)
        }
        
    }
    
    
    @objc func displayNextImage(){
        self.delegate?.displayNext(_scrollView: self)
        
        //过渡动画
        UIView.animate(withDuration: 0.5, animations: {
            if self.scrollView.subviews.count > 1  {
                let v = self.scrollView.subviews[1]
                v.alpha = 0
                if self.isScrollDirectionPortrait {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: 2 * self.scrollView.frame.size.height)
                    
                } else {
                    self.scrollView.contentOffset = CGPoint(x: 2 * self.scrollView.frame.size.width, y: 2 * 0)
                    
                }
            }
        }) { (finished) in
            if finished {
                self.displayImage()
            }
        }
    }
}


