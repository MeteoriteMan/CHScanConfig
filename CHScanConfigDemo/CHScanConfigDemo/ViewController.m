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
            self.viewInterest.hidden = NO;
            self.scanConfig = [[CHScanConfig alloc] initWithScanView:self.view rectOfInterest:self.viewInterest.frame];
            self.scanConfig.scanResultBlock = ^(CHScanConfig *scanConfig, NSArray<NSString *> *stringValues) {
                NSLog(@"%@", stringValues);
            };
            [self.scanConfig startRunning];
        } else {
            self.viewInterest.hidden = YES;
        }
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.scanConfig canTorch]) {
        [self.scanConfig setTorch:!self.scanConfig.isTorch];
    }
}


@end
