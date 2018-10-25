//
//  TDScrollRulerView.swift
//  PaishengFinance
//
//  Created by lisilong on 2018/2/2.
//  Copyright © 2018年 TDW.CN. All rights reserved.
//

import UIKit

fileprivate var textRulerFont    = UIFont.systemFont(ofSize: 12)    // 尺子标码字体大小
fileprivate var textFont         = UIFont.systemFont(ofSize: 11)    // 尺子文案字体大小

fileprivate let rulerGap         = 8
fileprivate let rulerLong        = 12
fileprivate let rulerShort       = 6
fileprivate var collectionHeight = 55.0
fileprivate let labelHeight      = 12.0
fileprivate let merge            = 3.0
fileprivate let lineWidth: CGFloat = 0.5
fileprivate let textHeight: CGFloat = 14.0
fileprivate let defaultColor: UIColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)


/***************TD************分************割************线***********/

class TDRulerView: UIView {
    var minValue: CGFloat = 0.0
    var maxValue: CGFloat = 0.0
    var unit: String  = ""
    var step: CGFloat = 0.0
    var betweenNumber = 0
    var strokeColor: UIColor = defaultColor
    var startNum: CGFloat = 0.0 {   // 起点值
        didSet {
            var startNumStr = String(format: "%.0f%@", startNum, unit)
            if startNum > 1000000 {
                startNumStr = String(format: "%.2f万%@", startNum/10000, unit)
            }
            infoLabel.text = startNumStr
        }
    }
    
    lazy var infoLabel: UILabel = {
        let info        = UILabel()
        info.text       = "0"
        info.font       = textRulerFont
        info.textAlignment = .center
        info.tag = 667
        info.isHidden = false
        return info
    }()
    
    init(frame: CGRect, strokeColor: UIColor = defaultColor, betweenNumber: Int) {
        super.init(frame: frame)
        
        self.strokeColor = strokeColor
        self.betweenNumber = betweenNumber
        
        // 刻度值
        let width: CGFloat   = 60.0
        let textTopY:CGFloat = frame.size.height - CGFloat(rulerLong) - 5.0 - textHeight
        infoLabel.frame      = CGRect(x: 0 - width / 2, y: textTopY, width: width, height: textHeight)
        infoLabel.textColor  = strokeColor
        addSubview(infoLabel)
        
        // 长刻度
        let longLineY = frame.size.height - CGFloat(rulerLong)
        let line      = UIView(frame: CGRect(x: 0, y: longLineY, width: lineWidth, height: CGFloat(rulerLong)))
        line.backgroundColor = strokeColor
        addSubview(line)
        
        // 短刻度
        let lineCenterX = CGFloat(rulerGap)
        let shortLineY  = frame.size.height - CGFloat(rulerShort)
        
        if betweenNumber > 0 {
            for i in 0...betweenNumber {
                let line = UIView(frame: CGRect(x: lineCenterX*CGFloat(i), y: shortLineY, width: lineWidth, height: CGFloat(rulerShort)))
                line.backgroundColor = strokeColor
                addSubview(line)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let startX:CGFloat   = 0
        let lineCenterX      = CGFloat(rulerGap)
        let textTopY:CGFloat = rect.size.height - CGFloat(rulerLong) - 5.0 - textHeight
        
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(strokeColor.cgColor)
        for i in 0...betweenNumber {
            if i%betweenNumber == 0 {
                let num = CGFloat(i)*step+minValue
                let info: UILabel? = self.viewWithTag(667) as? UILabel
                if num == startNum {
                    info?.isHidden = false
                } else {
                    if i == 0 { // 表示cell的头部文案
                        info?.isHidden = true
                    }
                    
                    var numStr = String(format: "%.0f%@", num, unit)
                    if num > 1000000 {
                        numStr = String(format: "%.2f万%@", num/10000, unit)
                    }
                    let attribute:Dictionary = [NSAttributedString.Key.font:textRulerFont,NSAttributedString.Key.foregroundColor: strokeColor] as [NSAttributedString.Key : Any]
                    let width = numStr.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                    attributes: attribute,context: nil).size.width
                    numStr.draw(in: CGRect.init(x: startX+lineCenterX*CGFloat(i)-width/2, y: textTopY, width: width, height: textHeight), withAttributes: attribute)
                }
            } else {}
            context!.strokePath()
        }
    }
}

/***************TD************分************割************线***********/

class TDFooterRulerView: UIView {
    var footerMaxValue = 0
    var footerUnit = ""
    var strokeColor: UIColor =  defaultColor
    
    init(frame: CGRect, strokeColor: UIColor = defaultColor) {
        super.init(frame: frame)
        
        self.strokeColor = strokeColor
        
        let shortLineY = frame.size.height - CGFloat(labelHeight + merge + Double(rulerLong))
        let line = UIView.init(frame: CGRect(x: 0, y: shortLineY, width: lineWidth, height: CGFloat(rulerLong)))
        line.backgroundColor = strokeColor
        self.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let textTopY: CGFloat = rect.size.height - CGFloat(labelHeight + merge) - CGFloat(rulerLong) - 5.0 - textHeight
        let context = UIGraphicsGetCurrentContext()
        var numStr:NSString = NSString(format: "%d%@", footerMaxValue,footerUnit)
        if footerMaxValue > 1000000 {
            numStr = NSString(format: "%.2f万%@", footerMaxValue/10000,footerUnit)
        }
        let attribute:Dictionary = [NSAttributedString.Key.font:textRulerFont,NSAttributedString.Key.foregroundColor:strokeColor] as [NSAttributedString.Key : Any]
        let width = numStr.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                        attributes: attribute,context: nil).size.width
        numStr.draw(in: CGRect(x: CGFloat(0 - width / 2), y: textTopY, width: width, height: textHeight), withAttributes: attribute)
        context!.strokePath()
    }
}

/***************TD************分************割************线***********/

protocol TDScrollRulerDelegate: NSObjectProtocol {
    
    /// 滚动时，返回当前值
    ///
    /// - Parameters:
    ///   - value: 当前值
    func scrollViewDidScroll(value: CGFloat)
    
    /// 尺子即将被拖拽
    ///
    /// - Parameter value: 当前值
    func scrollViewWillBeginDragging(value: CGFloat)
    
    /// 尺子停止滚动协议
    ///
    /// - Parameter value: 停止滚动值
    func scrollViewDidEndDragging(value: CGFloat)
    
    /// 尺子滚动动画停止协议
    ///
    /// - Parameter value: 停止滚动值
    func scrollViewDidEndScrollingAnimation(value: CGFloat)
}

class TDScrollRulerView: UIView {
    private lazy var lazyCollectionView: UICollectionView = { [unowned self] in
        let flowLayout              = UICollectionViewFlowLayout()
        flowLayout.scrollDirection  = UICollectionView.ScrollDirection.horizontal
        flowLayout.sectionInset     = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        let view = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: CGFloat(collectionHeight)), collectionViewLayout: flowLayout)
        view.backgroundColor    = .white
        view.bounces            = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator   = false
        view.delegate   = self
        view.dataSource = self
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "headCell")
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "footerCell")
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "customeCell")
        return view
        }()
    private var betweenNum:Int = 0
    private var stepNum        = 0    // 分多少个大区
    
    var maxValue: CGFloat     = 0.0   // 最大值
    var minValue: CGFloat     = 0.0   // 最小值
    var step: CGFloat         = 0.0   // 每个区被分割的分数
    var unit: String          = ""    // 单位
    
    var endNumber: CGFloat   = 0.0                  // 最大有效值
    var endNumText: String   = ""                   // 最大有效值文案
    var endNumTextColor: UIColor = .orange          // 最大有效值文案
    var strokeColor: UIColor     = .lightGray       // 标尺颜色
    
    weak var delegate: TDScrollRulerDelegate?
    
    // init
    
    /// 游标卡尺
    ///
    /// - Parameters:
    ///   - frame: 卡尺大小
    ///   - min: 卡尺最小值
    ///   - max: 卡尺最大值
    ///   - part: 每个区被分割的分数
    ///   - step: 一个区间的大小，默认1000
    ///   - unit: 单位
    ///   - numFontSize: 数值文字大小
    ///   - endNum: 最大有效值
    ///   - endText: 最大有效值文案
    ///   - endTextColor: 最大有效值文案颜色
    ///   - endtextFontSize: 最大有效值文案字体大小
    ///   - strokeColor: 卡尺颜色
    public init(frame: CGRect, strokeColor: UIColor, middleLineColor: UIColor, min: CGFloat, max: CGFloat, part: Int = 10, step: Int = 1000, unit: String = "", numFontSize: CGFloat, endNum: CGFloat, endText: String, endTextColor: UIColor, endtextFontSize: CGFloat) {
        super.init(frame: frame)
        backgroundColor = .white
        
        self.strokeColor = strokeColor
        self.maxValue        = max
        self.minValue        = min
        self.step            = CGFloat(step / 10)
        self.unit            = unit
        self.endNumber       = endNum
        self.endNumText      = endText
        self.endNumTextColor = endTextColor
        self.betweenNum      = part
        self.stepNum         = Int((max - min) / CGFloat(self.step)) / self.betweenNum
        
        textRulerFont = UIFont.systemFont(ofSize: numFontSize > 10 ? numFontSize : 12)
        
        collectionHeight = Double(frame.size.height)
        
        lazyCollectionView.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: CGFloat(collectionHeight))
        self.addSubview(lazyCollectionView)
        
        let lineH = collectionHeight - labelHeight - merge
        let line = UIView.init(frame: CGRect(x: self.bounds.size.width / 2.0 - (lineWidth / 2), y: 0, width: lineWidth, height: CGFloat(lineH)))
        line.backgroundColor = middleLineColor
        self.addSubview(line)
        
        let bottomLine = UIView(frame: CGRect(x: 0, y: CGFloat(collectionHeight) - CGFloat(labelHeight + merge), width: frame.size.width, height: lineWidth))
        bottomLine.backgroundColor = strokeColor
        addSubview(bottomLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadRulerView(min: CGFloat, max: CGFloat, part: Int = 10, step: Int = 1000, unit: String = "", numFontSize: CGFloat, endNum: CGFloat, endText: String, endTextColor: UIColor, endtextFontSize: CGFloat) {
        
        self.maxValue        = max
        self.minValue        = min
        self.step            = CGFloat(step / 10)
        self.unit            = unit
        self.endNumber       = endNum
        self.endNumText      = endText
        self.endNumTextColor = endTextColor
        self.betweenNum      = part
        self.stepNum         = Int((max - min) / CGFloat(self.step)) / self.betweenNum
        
        textRulerFont = UIFont.systemFont(ofSize: numFontSize > 10 ? numFontSize : 12)
        lazyCollectionView.reloadData()
    }
    
    // actions
    
    /// 滚动到指定值的位置
    ///
    /// - Parameter endN: 指定的值
    public func scrollToEndNumber(endN: CGFloat, animated: Bool = true) {
        if (endN - minValue) >= 0.0 {
            self.setRealValueAndAnimated(realValue: (endN - minValue) / step, animated: true)
        }
    }
    
    func setRealValueAndAnimated(realValue: CGFloat, animated: Bool) {
        lazyCollectionView.setContentOffset(CGPoint.init(x: Int(realValue) * rulerGap, y: 0), animated: animated)
    }
}


// MARK: - <UICollectionViewDataSource>

extension TDScrollRulerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2 + stepNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "headCell", for: indexPath)
            return cell
            
        } else if indexPath.item == stepNum+1 {
            let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "footerCell", for: indexPath)
            var footerView:TDFooterRulerView? = cell.contentView.viewWithTag(1001) as? TDFooterRulerView
            if footerView == nil {
                let frame = CGRect.init(x: 0, y: 0, width: Int(self.frame.size.width/2), height: Int(collectionHeight))
                footerView = TDFooterRulerView(frame: frame, strokeColor: strokeColor)
                footerView!.backgroundColor  = .clear
                footerView!.footerMaxValue   = Int(maxValue)
                footerView!.footerUnit       = unit
                footerView!.tag              = 1001
                footerView!.strokeColor      = strokeColor
                cell.contentView.addSubview(footerView!)
            }
            return cell
            
        } else {
            let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "customeCell", for: indexPath)
            var rulerView: TDRulerView? = cell.contentView.viewWithTag(1002) as? TDRulerView
            if rulerView == nil {
                let frame = CGRect.init(x: 0, y: 0, width: rulerGap*betweenNum, height: Int(collectionHeight - labelHeight - merge))
                rulerView = TDRulerView(frame: frame, strokeColor: strokeColor, betweenNumber: betweenNum)
                rulerView!.backgroundColor   = .white
                rulerView!.step              = step
                rulerView!.unit              = unit
                rulerView?.startNum          = minValue
                rulerView!.tag               = 1002
                cell.contentView.addSubview(rulerView!)
                
                let endNumLabel = UILabel()
                endNumLabel.textColor = endNumTextColor
                endNumLabel.textAlignment = .center
                endNumLabel.font  = textFont
                endNumLabel.adjustsFontSizeToFitWidth = true
                endNumLabel.text  = endNumText
                endNumLabel.frame = CGRect(x: 0.0, y: Double(rulerView!.bounds.size.height + CGFloat(merge)), width: Double(cell.bounds.size.width), height: labelHeight)
                endNumLabel.isHidden = true
                endNumLabel.tag = 9999
                cell.contentView.addSubview(endNumLabel)
                
                let line = UIView()
                line.backgroundColor = endNumTextColor
                line.tag = 9998
                line.isHidden = true
                cell.contentView.insertSubview(line, aboveSubview: rulerView!)
            }
            
            rulerView!.minValue = step * CGFloat((indexPath.item-1)) * CGFloat(betweenNum) + minValue
            rulerView!.maxValue = step * CGFloat(indexPath.item) * CGFloat(betweenNum)
            rulerView!.setNeedsDisplay()
            
            // 显示限制最大值
            let endNumLabel: UILabel? = cell.contentView.viewWithTag(9999) as? UILabel
            let line: UIView? = cell.contentView.viewWithTag(9998)
            var isHidden = true
            if rulerView?.minValue != nil, rulerView?.maxValue != nil {
                if endNumber > (rulerView?.minValue)!, endNumber <= (rulerView?.maxValue)! {
                    isHidden = false
                    
                    let end = endNumber - (rulerView?.minValue)!
                    let n: Int = Int(end / step)
                    let lineH = (n != 10) ? rulerShort : rulerLong
                    let x: CGFloat = CGFloat(n) * cell.bounds.size.width / CGFloat(betweenNum) - 0.5
                    let y: CGFloat = cell.bounds.size.height - CGFloat(lineH) - CGFloat(labelHeight) - CGFloat(merge)
                    line?.frame = CGRect(x: x, y: y, width: lineWidth, height: CGFloat(lineH))
                    endNumLabel?.center.x = (line?.center.x)!
                    endNumLabel?.text  = endNumText
                }
            }
            endNumLabel?.isHidden = isHidden
            line?.isHidden = isHidden
            return cell
        }
    }
}


// MARK: - <UICollectionViewDelegate>

extension TDScrollRulerView: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value      = Int(scrollView.contentOffset.x) / rulerGap
        let totalValue = CGFloat(value) * step + minValue
        delegate?.scrollViewDidScroll(value: totalValue)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let value      = Int(scrollView.contentOffset.x) / rulerGap
        let totalValue = CGFloat(value) * step + minValue
        delegate?.scrollViewWillBeginDragging(value: totalValue)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            // 1. 当不带滚动动画的时候，调节标尺
            self.updateScrollViewContentOffsetX(scrollView)
        } else {}
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let value      = Int(scrollView.contentOffset.x) / rulerGap
        let totalValue = CGFloat(value) * step + minValue
        delegate?.scrollViewDidEndScrollingAnimation(value: totalValue)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 2. 当带滚动动画的时候，调节标尺
        self.updateScrollViewContentOffsetX(scrollView)
    }
    
    func updateScrollViewContentOffsetX(_ scrollView: UIScrollView) {
        self.setRealValueAndAnimated(realValue: CGFloat(scrollView.contentOffset.x) / CGFloat(rulerGap), animated: true)
        let value      = Int(scrollView.contentOffset.x) / rulerGap
        let totalValue = CGFloat(value) * step + minValue
        delegate?.scrollViewDidEndDragging(value: totalValue)
    }
}


// MARK: - <UICollectionViewDelegateFlowLayout>

extension TDScrollRulerView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 || indexPath.item == stepNum + 1 {
            return CGSize(width: Double(self.frame.size.width / 2), height: collectionHeight)
        }
        return CGSize(width: Double(rulerGap * betweenNum), height: collectionHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

