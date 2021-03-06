//
//  CHScanConfig.h
//  CHScanConfigDemo
//
//  Created by 张晨晖 on 2019/3/15.
//  Copyright © 2019 张晨晖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class CHScanConfig;

typedef NS_ENUM(NSUInteger, CHScanType) {
    /// QR码
    CHScanTypeQRCode,
    /// 条形码
    CHScanTypeBarCode,
    /// 二维码
    CHScanType2DCode,
    /// 二维码/条形码
    CHScanTypeCommon,
};

@protocol CHScanConfigDelegate <NSObject>

@optional
- (void)scanConfig:(CHScanConfig *)scanConfig scanResult:(NSArray <NSString *> *)stringValues;

@end

typedef void(^CHScanConfigScanResultBlock)(CHScanConfig *scanConfig, NSArray <NSString *> *stringValues);
typedef void(^CHScanConfigScanImageResultBlock)(NSArray <NSString *> *stringValues);

@interface CHScanConfig : NSObject

#pragma mark 权限有关

/**
 检测是否开启了相机权限

 @param completeHandle canOpen?@"开启了相机权限":@"未开启相机权限"
 */
+ (void)canOpenScan:(void(^)(BOOL canOpen))completeHandle;

#pragma mark 扫码有关

/**
 创建扫码View

 @param scanView 扫码View显示的位置
 @return CHScanConfig
 */
- (instancetype)initWithScanView:(UIView *)scanView;

/**
 创建扫码View
 @param scanView 扫码View显示的位置
 @param interestView 识别View
 @return CHScanConfig
 */
- (instancetype)initWithScanView:(UIView *)scanView interestView:(UIView *)interestView;

/**
 扫码类型.二维码/条形码/QRCode/通用.默认QRCode
 */
@property (nonatomic ,assign) CHScanType scanType;

/// 单独设置扫码类型
@property (nonatomic ,strong) NSArray <AVMetadataObjectType> *metadataObjectTypes;

@property (nonatomic ,weak) id <CHScanConfigDelegate> delegate;

/**
 扫码回调
 */
@property (nonatomic ,copy) CHScanConfigScanResultBlock scanResultBlock;

/**
 开始扫码
 */
- (void)startRunning;

/**
 停止扫码
 */
- (void)stopRunning;

#pragma mark 闪光灯有关

/**
 是否支持闪光灯

 @return BOOL?支持:不支持
 */
- (BOOL)canTorch;

/**
 闪光灯是否是开启状态

 @return BOOL?开启:未开启
 */
- (BOOL)isTorch;

/**
 设置闪光灯打开/关闭

 @param torch torch?打开/关闭
 */
- (void)setTorch:(BOOL)torch;

/**
 获取闪光灯亮度

 @return 闪光灯亮度
 */
- (float)torch;

/**
 设置闪光灯强度

 @param torchLevel 0.0-1.0
 */
- (void)setTorchLevel:(float)torchLevel;

#pragma mark 缩放有关

/**
 获取当前输入图像缩放比例

 @return 当前输入图像缩放比例
 */
- (float)videoZoomFactor;

/**
 最大支持缩放比例

 @return 最大支持缩放比例
 */
- (float)maxAvailableVideoZoomFactor API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(macos);

/**
 最小支持缩放比例

 @return 最小支持缩放比例
 */
- (float)minAvailableVideoZoomFactor API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(macos);

/**
 设置输入图像缩放比例

 @param videoZoomFactor 1.0~max
 */
- (void)setVideoZoomFactor:(float)videoZoomFactor;

/**
 还原输入图像缩放比例.1.0
 */
- (void)setVideoZoomFactorIdentity;

#pragma mark 屏幕亮度

/**
 获取屏幕亮度

 @return 返回屏幕亮度0.0-1.0
 */
- (CGFloat)screenBrightness;

/**
 设置屏幕亮度

 @param screenBrightness 0.0-1.0
 */
- (void)setScreenBrightness:(CGFloat)screenBrightness;

#pragma mark 识别本地图片(QRCode)
+ (void)recognizeImage:(UIImage *)image resultBlock:(CHScanConfigScanImageResultBlock)resultBlock;

#pragma mark 生成QRCode(可以是中文或者是emoji)
+ (UIImage *)creatQRCodeImageWithString:(NSString *)QRCodeString imageSize:(CGSize)imageSize;

#pragma mark 生成条形码(要识别的话只能是数字.字母)
+ (UIImage *)creatCode128BarCodeImageWithString:(NSString *)code128BarCodeString imageSize:(CGSize)imageSize;

#pragma mark 生成PDF417码(要识别的话只能是数字.字母,空格会自动去掉)
+ (UIImage *)creatPDF417BarCodeImageWithString:(NSString *)PDF417BarCodeString imageSize:(CGSize)imageSize;

#pragma mark 生成aztec码(要识别的话只能是数字.字母,符号会去掉,空格保留)
+ (UIImage *)creatAztecCodeImageWithString:(NSString *)aztecCodeString imageSize:(CGSize)imageSize;

@end
