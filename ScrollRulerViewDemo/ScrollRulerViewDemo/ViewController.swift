//
//  ViewController.swift
//  ScrollRulerViewDemo
//
//  Created by lisilong on 2018/2/7.
//  Copyright © 2018年 tuandai. All rights reserved.
//

import UIKit

// 屏幕宽度
let ScreenWidth = UIScreen.main.bounds.width
// 屏幕高度
let ScreenHeight = UIScreen.main.bounds.height

class ViewController: UIViewController {
    lazy var lazyRulerView: TDScrollRulerView = { [unowned self] in
        var rulerView = TDScrollRulerView(frame: CGRect(x: 0, y: Int(ScreenHeight/2), width: Int(ScreenWidth), height: 67),
                                          strokeColor: UIColor.lightGray,
                                          middleLineColor: .red,
                                          min: 0.0,
                                          max: 10000,
                                          numFontSize: 12,
                                          endNum: 6666,
                                          endText: "剩余金额",
                                          endTextColor: UIColor.orange,
                                          endtextFontSize: 11)
        rulerView.delegate = self
        return rulerView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(lazyRulerView)
        lazyRulerView.reloadRulerView(min: 0.0, max: 10000, numFontSize: 12, endNum: 6666, endText: "剩余金额", endTextColor: UIColor.orange, endtextFontSize: 11)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lazyRulerView.scrollToEndNumber(endN: 6666)
    }
}

extension ViewController: TDScrollRulerDelegate {
    func scrollViewWillBeginDragging(value: CGFloat) {
    }
    
    func scrollViewDidEndScrollingAnimation(value: CGFloat) {
    }
    func scrollViewDidScroll(value: CGFloat) {
        print("滑动的值------->"+"\(value)")
    }
    
    func scrollViewDidEndDragging(value: CGFloat) {
        print("滑动的值end------->"+"\(value)")
        if value > 6666 {
            lazyRulerView.scrollToEndNumber(endN: 6666)
        }
    }
}
