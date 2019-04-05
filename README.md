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

## 安装

使用 [CocoaPods](http://www.cocoapods.com/) 集成.
首先在podfile中
>`pod 'CHScanConfig'`

安装一下pod

>`#import <CHScanConfig/CHScanConfigHeader.h>`


## 更新记录

**CocoaPods出了点问题.0.0.1、0.0.2推不上去**

|版本|更新内容|
|:--|:--|
|0.0.3|支持生成、识别二维码/条形码(扫码或者是图库中的).|