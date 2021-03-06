//
//  CHScanConfig.m
//  CHScanConfigDemo
//
//  Created by 张晨晖 on 2019/3/15.
//  Copyright © 2019 张晨晖. All rights reserved.
//

#import "CHScanConfig.h"

@interface CHScanConfig () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic ,strong) AVCaptureSession *session;

@property (nonatomic ,strong) AVCaptureDeviceInput *input;

@property (nonatomic ,strong) AVCaptureMetadataOutput *output;

@property (nonatomic ,strong) AVCaptureVideoPreviewLayer *layerOutput;

@property (nonatomic ,strong) UIView *scanView;

@property (nonatomic ,strong) UIView *interestView;

@end

@implementation CHScanConfig

static NSString *frameKey = @"frame";
static NSString *boundsKey = @"bounds";
static NSString *centerKey = @"center";
static NSString *CHScanViewKey = @"CHScanViewKey";
static NSString *CHInterestViewKey = @"CHInterestViewKey";

+ (void)canOpenScan:(void(^)(BOOL canOpen))completeHandle {
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusAuthorized: {
            if (completeHandle) {
                completeHandle(YES);
            }
        }
            break;
        case AVAuthorizationStatusNotDetermined: {
            /// 该应用尚未请求过权限
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
            break;
        case AVAuthorizationStatusDenied: {
            if (completeHandle) {
                completeHandle(NO);
            }
        }
            break;
        case AVAuthorizationStatusRestricted: {
            /// 受限
            if (completeHandle) {
                completeHandle(NO);
            }
        }
            break;
    }
}

- (instancetype)initWithScanView:(UIView *)scanView {
    return [self initWithScanView:scanView interestView:nil];
}

- (instancetype)initWithScanView:(UIView *)scanView interestView:(UIView *)interestView {
    [self removeObservers];
    self.scanView = scanView;
    self.interestView = interestView;
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
    [self setLayerOutputWithInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
    [scanView.layer insertSublayer:self.layerOutput atIndex:0];
    [self setRectOfInterest];
    [self addObservers];
    return self;
}

- (void)setRectOfInterest {
    if (!CGRectEqualToRect(self.interestView.frame, CGRectZero) && self.interestView) {
        self.output.rectOfInterest = [self.layerOutput metadataOutputRectOfInterestForRect:self.interestView.frame];
    } else {
        self.output.rectOfInterest = CGRectMake(0, 0, 1, 1);
    }
}

- (void)setLayerOutputWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    self.layerOutput.connection.videoOrientation = [self transfromAVCaptureVideoOrientationFrom:interfaceOrientation];
}

- (void)setScanType:(CHScanType)scanType {
    _scanType = scanType;
    switch (scanType) {
        case CHScanTypeQRCode: {
            self.output.metadataObjectTypes = @[/// QRCode
                                                AVMetadataObjectTypeQRCode,
                                                ];

        }
            break;
        case CHScanTypeBarCode: {
            self.output.metadataObjectTypes = @[/// 条形码
                                                AVMetadataObjectTypeUPCECode,
                                                AVMetadataObjectTypeCode39Code,
                                                AVMetadataObjectTypeCode39Mod43Code,
                                                AVMetadataObjectTypeEAN13Code,
                                                AVMetadataObjectTypeEAN8Code,
                                                AVMetadataObjectTypeCode93Code,
                                                AVMetadataObjectTypeCode128Code,
                                                AVMetadataObjectTypeInterleaved2of5Code,
                                                AVMetadataObjectTypeITF14Code,
                                                ];

        }
            break;
        case CHScanType2DCode: {
            self.output.metadataObjectTypes = @[/// 二维码
                                                AVMetadataObjectTypePDF417Code,
                                                AVMetadataObjectTypeQRCode,
                                                AVMetadataObjectTypeAztecCode,
                                                AVMetadataObjectTypeDataMatrixCode,
                                                ];
        }
            break;
        case CHScanTypeCommon: {
            self.output.metadataObjectTypes = @[/// 条形码
                                                AVMetadataObjectTypeUPCECode,
                                                AVMetadataObjectTypeCode39Code,
                                                AVMetadataObjectTypeCode39Mod43Code,
                                                AVMetadataObjectTypeEAN13Code,
                                                AVMetadataObjectTypeEAN8Code,
                                                AVMetadataObjectTypeCode93Code,
                                                AVMetadataObjectTypeCode128Code,
                                                AVMetadataObjectTypeInterleaved2of5Code,
                                                AVMetadataObjectTypeITF14Code,
                                                /// 二维码
                                                AVMetadataObjectTypePDF417Code,
                                                AVMetadataObjectTypeQRCode,
                                                AVMetadataObjectTypeAztecCode,
                                                AVMetadataObjectTypeDataMatrixCode,
                                              ];
        }
            break;
        default:
            break;
    }
}

- (void)setMetadataObjectTypes:(NSArray<AVMetadataObjectType> *)metadataObjectTypes {
    _metadataObjectTypes = metadataObjectTypes;
    self.output.metadataObjectTypes = metadataObjectTypes;
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
    if (videoZoomFactor >= 1.0) {
        [self.input.device lockForConfiguration:nil];
        self.input.device.videoZoomFactor = videoZoomFactor;
        [self.input.device unlockForConfiguration];
    }
}

- (void)setVideoZoomFactorIdentity {
    [self setVideoZoomFactor:1.0];
}

- (CGFloat)screenBrightness {
    return UIScreen.mainScreen.brightness;
}

- (void)setScreenBrightness:(CGFloat)screenBrightness {
    UIScreen.mainScreen.brightness = screenBrightness;
}

+ (void)recognizeImage:(UIImage *)image resultBlock:(CHScanConfigScanImageResultBlock)resultBlock {
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    NSMutableArray *arrayM = [[NSMutableArray alloc] init];
    for (CIQRCodeFeature *feature in features) {
        [arrayM addObject:feature.messageString];
    }
    if (resultBlock) {
        resultBlock(arrayM.copy);
    }
}

/// MARK: Code绘制
+ (UIImage *)creatQRCodeImageWithString:(NSString *)QRCodeString imageSize:(CGSize)imageSize {
    return [self creatCodeImageFilterName:@"CIQRCodeGenerator" codeString:QRCodeString imageSize:imageSize];
}

+ (UIImage *)creatCode128BarCodeImageWithString:(NSString *)code128BarCodeString imageSize:(CGSize)imageSize {
    return [self creatCodeImageFilterName:@"CICode128BarcodeGenerator" codeString:code128BarCodeString imageSize:imageSize];
}

+ (UIImage *)creatPDF417BarCodeImageWithString:(NSString *)PDF417BarCodeString imageSize:(CGSize)imageSize {
    return [self creatCodeImageFilterName:@"CIPDF417BarcodeGenerator" codeString:PDF417BarCodeString imageSize:imageSize];
}

+ (UIImage *)creatAztecCodeImageWithString:(NSString *)aztecCodeString imageSize:(CGSize)imageSize {
    return [self creatCodeImageFilterName:@"CIAztecCodeGenerator" codeString:aztecCodeString imageSize:imageSize];
}

+ (UIImage *)creatCodeImageFilterName:(NSString *)filterName codeString:(NSString *)codeString imageSize:(CGSize)imageSize {
    // 1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:filterName];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSData *data = [codeString dataUsingEncoding:NSUTF8StringEncoding];
    // 4.1 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 4.2  消除边界 (条形码可以设置.PDF417、aztec崩溃)
    @try {
        [filter setValue:[NSNumber numberWithInteger:0] forKey:@"inputQuietSpace"];
    } @catch (NSException *exception) {
    } @finally {
    }
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = filter.outputImage;
    // 6. 将CIImage转换成UIImage，并放大显示
    CGFloat size = CGFLOAT_MIN;
    if (imageSize.height >= imageSize.width) {
        size = imageSize.height;
    } else {
        size = imageSize.width;
    }
    return [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:size];
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

// MARK: Notifications
- (void)applicationDidChangeStatusBarOrientationNotification:(NSNotification *)notification {
    if ([notification.name isEqualToString:UIApplicationDidChangeStatusBarOrientationNotification]) {
        [self setLayerOutputWithInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
    }
}

// MARK:Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == (__bridge void * _Nullable)(CHScanViewKey)) {
        self.layerOutput.frame = self.scanView.bounds;
    } else if (context == (__bridge void * _Nullable)(CHInterestViewKey)) {
        [self setRectOfInterest];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [self removeObservers];
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [self.scanView addObserver:self forKeyPath:frameKey options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(CHScanViewKey)];
    [self.scanView addObserver:self forKeyPath:boundsKey options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(CHScanViewKey)];
    [self.scanView addObserver:self forKeyPath:centerKey options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(CHScanViewKey)];
    [self.interestView addObserver:self forKeyPath:frameKey options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(CHInterestViewKey)];
    [self.interestView addObserver:self forKeyPath:boundsKey options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(CHInterestViewKey)];
    [self.interestView addObserver:self forKeyPath:centerKey options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(CHInterestViewKey)];
}

- (void)removeObservers {
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        [self.scanView removeObserver:self forKeyPath:frameKey context:(__bridge void * _Nullable)(CHScanViewKey)];
        [self.scanView removeObserver:self forKeyPath:boundsKey context:(__bridge void * _Nullable)(CHScanViewKey)];
        [self.scanView removeObserver:self forKeyPath:centerKey context:(__bridge void * _Nullable)(CHScanViewKey)];
        [self.interestView removeObserver:self forKeyPath:frameKey context:(__bridge void * _Nullable)(CHInterestViewKey)];
        [self.interestView removeObserver:self forKeyPath:boundsKey context:(__bridge void * _Nullable)(CHInterestViewKey)];
        [self.interestView removeObserver:self forKeyPath:centerKey context:(__bridge void * _Nullable)(CHInterestViewKey)];
    } @catch (NSException *exception) {
    } @finally {
    }
}

// MARK: AVCaptureVideoOrientation转换函数
- (AVCaptureVideoOrientation)transfromAVCaptureVideoOrientationFrom:(UIInterfaceOrientation)interfaceOrientation {
    switch (interfaceOrientation) {
        case UIInterfaceOrientationUnknown:
            return AVCaptureVideoOrientationPortrait;
            break;
        case UIInterfaceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            return AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
            break;
        default:
            return AVCaptureVideoOrientationPortrait;
            break;
    }
}

@end
