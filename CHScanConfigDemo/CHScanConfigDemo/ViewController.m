//
//  ViewController.m
//  CHScanConfigDemo
//
//  Created by 张晨晖 on 2019/4/1.
//  Copyright © 2019 张晨晖. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "CHScanConfigHeader.h"

@interface ViewController ()

@property (nonatomic ,strong) UIView *viewInterest;

@property (nonatomic ,strong) CHScanConfig *scanConfig;

@property (nonatomic ,strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.viewInterest = [UIView new];
    self.viewInterest.backgroundColor = [UIColor colorWithRed:.25 green:.25 blue:.25 alpha:.75];
    self.viewInterest.hidden = YES;
    [self.view addSubview:self.viewInterest];
    [self.viewInterest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide).offset(12);
        make.height.width.offset(200);
    }];
    [self.viewInterest layoutIfNeeded];

    [CHScanConfig canOpenScan:^(BOOL canOpen) {
        if (canOpen) {
//            self.viewInterest.hidden = NO;
            self.scanConfig = [[CHScanConfig alloc] initWithScanView:self.view];
//            [[CHScanConfig alloc] initWithScanView:self.view rectOfInterest:self.viewInterest.frame];
            self.scanConfig.scanType = CHScanTypeBarCode;
            self.scanConfig.scanResultBlock = ^(CHScanConfig *scanConfig, NSArray<NSString *> *stringValues) {
                NSLog(@"%@", stringValues);
            };
            [self.scanConfig startRunning];
        } else {
//            self.viewInterest.hidden = YES;
        }
    }];

    /// 生成码
//    self.imageView = [[UIImageView alloc] init];
//    [self.view addSubview:self.imageView];
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
//        make.width.offset(440);
////        make.height.width.offset(200);
//        make.height.offset(200);
//    }];
//    [self.imageView layoutIfNeeded];
////    0300054757708
//    /// 条形码
//    self.imageView.image = [CHScanConfig creatCode128BarCodeImageWithString:@"12345678" imageSize:self.imageView.bounds.size];
//    /// 二维码
////    self.imageView.image = [CHScanConfig creatQRCodeImageWithString:@"12345678" imageSize:self.imageView.bounds.size];
////    /// PDF417码
////    self.imageView.image = [CHScanConfig creatPDF417BarCodeImageWithString:@"12345678" imageSize:self.imageView.bounds.size];
////    /// aztec
////    self.imageView.image = [CHScanConfig creatAztecCodeImageWithString:@"12345678" imageSize:self.imageView.bounds.size];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if ([self.scanConfig canTorch]) {
//        [self.scanConfig setTorch:!self.scanConfig.isTorch];
//    }
}


@end
