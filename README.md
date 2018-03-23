#Swift--一个好用的金融类游标卡尺
> 思路：
> 
> 使用UICollectionView制作一个游标卡尺，每一个cell代表一个刻度区间，每个区间间隔值、区间分割份数和卡尺样式等都是可设置的。通过代理协议，监听卡尺的滚动值，设置卡尺的显示值等等。也可以设置默认最大可用金额，当用户滚动卡尺超过最大可用金额时自动回滚等（自己项目中使用到）。[简书](https://www.jianshu.com/p/61289c14ec34)
> 
> 

## 效果图

![卡尺效果图1](http://upload-images.jianshu.io/upload_images/877439-cf1ea51440253eec.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![卡尺效果图2](http://upload-images.jianshu.io/upload_images/877439-d7c2d80ee72c5afe.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 初始化方法如下：
~~~Swift
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
public init(frame: CGRect, strokeColor: UIColor, middleLineColor: UIColor, min: CGFloat, max: CGFloat, part: Int = default, step: Int = default, unit: String = default, numFontSize: CGFloat, endNum: CGFloat, endText: String, endTextColor: UIColor, endtextFontSize: CGFloat)
~~~

## 如果是网络请求返回的数值，需要实时更新卡尺的，可调用
~~~Swift
/// 更新游标卡尺
///
/// - Parameters:
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
internal func reloadRulerView(min: CGFloat, max: CGFloat, part: Int = default, step: Int = default, unit: String = default, numFontSize: CGFloat, endNum: CGFloat, endText: String, endTextColor: UIColor, endtextFontSize: CGFloat)
~~~

## 设置卡尺的位置方法
~~~Swift
/// 设置卡尺显示值
///
/// - Parameter endN: 指定的值
public func scrollToEndNumber(endN: CGFloat, animated: Bool = default)
~~~

## 卡尺交互协议
~~~Swift
/// 滚动时，返回当前值
///
/// - Parameters:
///   - value: 当前值
internal func scrollViewDidScroll(value: CGFloat)

/// 尺子即将被拖拽
///
/// - Parameter value: 当前值
internal func scrollViewWillBeginDragging(value: CGFloat)

/// 尺子停止滚动协议
///
/// - Parameter value: 停止滚动值
internal func scrollViewDidEndDragging(value: CGFloat)

/// 尺子滚动动画停止协议
///
/// - Parameter value: 停止滚动值
internal func scrollViewDidEndScrollingAnimation(value: CGFloat)
~~~

[简书](https://www.jianshu.com/p/61289c14ec34)



