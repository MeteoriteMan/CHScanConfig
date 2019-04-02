//
//  CHScanConfig.m
//  CHScanConfigDemo
//
//  Created by 张晨晖 on 2019/3/15.
//  Copyright © 2019 张晨晖. All rights reserved.
//

#import "CHScanConfig.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"

@interface CHScanConfig () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic ,strong) AVCaptureSession *session;

@property (nonatomic ,strong) AVCaptureDeviceInput *input;

@property (nonatomic ,strong) AVCaptureMetadataOutput *output;

@property (nonatomic ,strong) AVCaptureVideoPreviewLayer *layerOutput;

@property (nonatomic ,strong) UIView *scanView;

@end

@implementation CHScanConfig

+ (void)canOpenScan:(void(^)(BOOL canOpen))completeHandle {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                if (completeHandle) {
                    completeHandle(YES);
                }
            } else {
                if (completeHandle) {
                    completeHandle(NO);
                }
            }
        });
    }];
}

- (instancetype)initWithScanView:(UIView *)scanView {
    return [self initWithScanView:scanView rectOfInterest:CGRectZero];
}

- (instancetype)initWithScanView:(UIView *)scanView rectOfInterest:(CGRect)rectOfInterest {
    self.scanView = scanView;
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    self.output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理 在主线程里刷新
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //初始化链接对象
    self.session = [[AVCaptureSession alloc] init];
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    self.scanType = CHScanTypeQRCode;
    self.layerOutput = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.layerOutput.frame = scanView.bounds;
    self.layerOutput.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [scanView.layer insertSublayer:self.layerOutput atIndex:0];
    if (!CGRectEqualToRect(rectOfInterest, CGRectZero)) {
        self.output.rectOfInterest = [self.layerOutput metadataOutputRectOfInterestForRect:rectOfInterest];
    }
    return self;
}

- (void)setScanType:(CHScanType)scanType {
    _scanType = scanType;
    switch (scanType) {
        case CHScanTypeQRCode: {
            self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];

        }
            break;
        case CHScanTypeBarCode: {
            self.output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
                                              AVMetadataObjectTypeEAN8Code,
                                              AVMetadataObjectTypeUPCECode,
                                              AVMetadataObjectTypeCode39Code,
                                              AVMetadataObjectTypeCode39Mod43Code,
                                              AVMetadataObjectTypeCode93Code,
                                              AVMetadataObjectTypeCode128Code,
                                              AVMetadataObjectTypePDF417Code];

        }
            break;
        case CHScanTypeCommon: {
            self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                              AVMetadataObjectTypeEAN13Code,
                                              AVMetadataObjectTypeEAN8Code,
                                              AVMetadataObjectTypeUPCECode,
                                              AVMetadataObjectTypeCode39Code,
                                              AVMetadataObjectTypeCode39Mod43Code,
                                              AVMetadataObjectTypeCode93Code,
                                              AVMetadataObjectTypeCode128Code,
                                              AVMetadataObjectTypePDF417Code];
        }
            break;
        default:
            break;
    }
}

- (void)startRunning {
    if (self.session.isRunning) {
        [self.session stopRunning];
    }
    [self.session startRunning];
}

- (void)stopRunning {
    if (self.session.isRunning) {
        [self.session stopRunning];
    }
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        [self stopRunning];
        NSMutableArray *arrayM = [NSMutableArray array];
        for (AVMetadataMachineReadableCodeObject *metadataObject in metadataObjects) {
            [arrayM addObject:metadataObject.stringValue];
        }
        if (self.scanResultBlock) {
            self.scanResultBlock(self, arrayM.copy);
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(scanConfig:scanResult:)]) {
            [self.delegate scanConfig:self scanResult:arrayM.copy];
        }
    }
}

- (BOOL)canTorch {
    if (self.input.device.hasTorch) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isTorch {
    switch (self.input.device.torchMode) {
        case AVCaptureTorchModeOn:
            return YES;
            break;
        case AVCaptureTorchModeOff:
            return NO;
            break;
        default:
            return NO;
            break;
    }
}

- (void)setTorch:(BOOL)torch {
    [self.input.device lockForConfiguration:nil];
    self.input.device.torchMode = torch?AVCaptureTorchModeOn:AVCaptureTorchModeOff;
    [self.input.device unlockForConfiguration];
}

- (float)torch {
    return self.input.device.torchLevel;
}

- (void)setTorchLevel:(float)torchLevel {
    [self.input.device lockForConfiguration:nil];
    [self.input.device setTorchModeOnWithLevel:torchLevel error:nil];
    [self.input.device unlockForConfiguration];
}

- (float)videoZoomFactor {
    return self.input.device.videoZoomFactor;
}

- (float)maxAvailableVideoZoomFactor {
    return self.input.device.maxAvailableVideoZoomFactor;
}

- (float)minAvailableVideoZoomFactor {
    return self.input.device.minAvailableVideoZoomFactor;
}

- (void)setVideoZoomFactor:(float)videoZoomFactor {
    [self.input.device lockForConfiguration:nil];
    self.input.device.videoZoomFactor = videoZoomFactor;
    [self.input.device unlockForConfiguration];
}

- (void)setVideoZoomFactorIdentity {
    [self setVideoZoomFactor:1.0];
}

+ (void)recognizeImage:(UIImage *)image resultBlock:(CHScanConfigScanImageResultBlock)resultBlock {
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    NSMutableArray *arrayM = [[NSMutableArray alloc] init];
    for (CIQRCodeFeature *feature in features) {
        [arrayM addObject:feature.messageString];
    }
    if (resultBlock) {
        resultBlock(arrayM.copy);
    }
}

+ (UIImage *)creatQRCodeImageWithString:(NSString *)QRCodeString imageSize:(CGSize)imageSize {
    // 1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSData *data = [QRCodeString dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    // 6. 将CIImage转换成UIImage，并放大显示
    CGFloat size = CGFLOAT_MIN;
    if (UIScreen.mainScreen.bounds.size.height >= UIScreen.mainScreen.bounds.size.width) {
        size = UIScreen.mainScreen.bounds.size.height;
    } else {
        size = UIScreen.mainScreen.bounds.size.width;
    }
    return [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:size];//重绘二维码,使其显示清晰
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (UIImage *)creatBarCodeImageWithString:(NSString *)barCodeString imageSize:(CGSize)imageSize {
    NSData *data = [barCodeString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *barcodeImage = [filter outputImage];
    // 消除模糊
    CGFloat scaleX = imageSize.width / barcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = imageSize.height / barcodeImage.extent.size.height;
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    return [UIImage imageWithCIImage:transformedImage];
}

@end
