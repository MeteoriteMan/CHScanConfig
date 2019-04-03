//
//  QRCodeScanViewController.m
//  CHScanConfigDemo
//
//  Created by 张晨晖 on 2019/4/3.
//  Copyright © 2019 张晨晖. All rights reserved.
//

#import "QRCodeScanViewController.h"
#import "ScanResultViewController.h"

@interface QRCodeScanViewController ()

@property (nonatomic ,strong) UIView *viewInterest;

@property (nonatomic ,strong) CHScanConfig *scanConfig;

@property (nonatomic ,strong) UIImageView *imageView;

@end

@implementation QRCodeScanViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.scanConfig startRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof(self) weakSelf = self;
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
            self.scanConfig.scanType = self.scanType;
            self.scanConfig.scanResultBlock = ^(CHScanConfig *scanConfig, NSArray<NSString *> *stringValues) {
                NSLog(@"%@", stringValues);
                ScanResultViewController *vc = [[ScanResultViewController alloc] init];
                vc.titleStr = stringValues.firstObject;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            [self.scanConfig startRunning];
        } else {
            //            self.viewInterest.hidden = YES;
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
