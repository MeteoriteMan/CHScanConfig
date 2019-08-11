# CHScanConfig
二维码/条形码扫码、生成.

## 效果

> 见Demo

## 使用

```
[CHScanConfig canOpenScan:^(BOOL canOpen) {
	if (canOpen) {
		self.scanConfig = [[CHScanConfig alloc] initWithScanView:self.view rectOfInterest:self.viewInterest.frame];
		self.scanConfig.scanResultBlock = ^(CHScanConfig *scanConfig, NSArray<NSString *> *stringValues) {
			NSLog(@"%@", stringValues);
		};
		[self.scanConfig startRunning];
	}
}];
```
**注** 默认支持的是扫描QRCode.

需要自定义扫码类型的设置

```
/// 单独设置扫码类型
@property (nonatomic ,strong) NSArray <AVMetadataObjectType> *metadataObjectTypes;
```

**另** 也可以快速设置支持类型

```
/**
 扫码类型.二维码/条形码/QRCode/通用.默认QRCode
 */
@property (nonatomic ,assign) CHScanType scanType;
```

## 安装

使用 [CocoaPods](http://www.cocoapods.com/) 集成.
首先在podfile中
>`pod 'CHScanConfig'`

安装一下pod

>`#import <CHScanConfig/CHScanConfigHeader.h>`

## 更新详情
### 0.0.4
> 修复了横屏情况下输出图片偏移的BUG.
> 现在支持自动转屏,转屏后扫码识别框的识别区域也会自动同步.

## 更新记录

**CocoaPods出了点问题(推成功了终端显示失败).0.0.1、0.0.2、0.0.3版本相同**

|版本|更新内容|
|:--|:--|
|0.0.5|优化权限请求|
|0.0.4|现支持转屏,重写识别框代码.|
|0.0.1~0.0.3|支持生成、识别二维码/条形码(扫码或者是图库中的).|