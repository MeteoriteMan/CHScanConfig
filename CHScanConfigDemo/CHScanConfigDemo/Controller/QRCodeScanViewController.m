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

@property (nonatomic ,strong) UIImageView *imageViewInterest;

@property (nonatomic ,strong) CHScanConfig *scanConfig;

@property (nonatomic ,strong) UIButton *buttonZoomFactorZero;

@property (nonatomic ,strong) UIButton *buttonZoomFactorUpper;

@property (nonatomic ,strong) UIButton *buttonZoomFactorDowner;

@property (nonatomic ,strong) UIButton *buttonTorch;

@property (nonatomic ,strong) UIButton *buttonTorchLighter;

@property (nonatomic ,strong) UIButton *buttonTorchDarker;
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
    self.imageViewInterest = [[UIImageView alloc] init];;
    self.imageViewInterest.image = [UIImage imageNamed:@"扫码框"];
    self.imageViewInterest.hidden = YES;
    [self.view addSubview:self.imageViewInterest];
    [self.imageViewInterest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide).offset(12);
        make.height.width.offset(200);
    }];

    [CHScanConfig canOpenScan:^(BOOL canOpen) {
        if (canOpen) {
            self.imageViewInterest.hidden = NO;
            self.scanConfig = [[CHScanConfig alloc] initWithScanView:self.view interestView:self.imageViewInterest];
            self.scanConfig.scanType = self.scanType;
            self.scanConfig.scanResultBlock = ^(CHScanConfig *scanConfig, NSArray<NSString *> *stringValues) {
                NSLog(@"%@", stringValues);
                ScanResultViewController *vc = [[ScanResultViewController alloc] init];
                vc.titleStr = stringValues.firstObject;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            [self.scanConfig startRunning];
        } else {
            self.imageViewInterest.hidden = YES;
        }
    }];

    self.buttonTorch = [UIButton new];
    [self.view addSubview:self.buttonTorch];
    [self.buttonTorch setImage:[UIImage imageNamed:@"手电筒 关"] forState:UIControlStateNormal];
    [self.buttonTorch setImage:[UIImage imageNamed:@"手电筒 开"] forState:UIControlStateSelected];
    [self.buttonTorch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-24);
        make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(-24);
    }];

    self.buttonTorchDarker = [UIButton new];
    [self.view addSubview:self.buttonTorchDarker];
    [self.buttonTorchDarker setImage:[UIImage imageNamed:@"减"] forState:UIControlStateNormal];
    [self.buttonTorchDarker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.buttonTorch);
        make.bottom.equalTo(self.buttonTorch.mas_top).offset(-24);
    }];

    self.buttonTorchLighter = [UIButton new];
    [self.view addSubview:self.buttonTorchLighter];
    [self.buttonTorchLighter setImage:[UIImage imageNamed:@"加"] forState:UIControlStateNormal];
    [self.buttonTorchLighter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.buttonTorchDarker);
        make.bottom.equalTo(self.buttonTorchDarker.mas_top).offset(-24);
    }];


    self.buttonZoomFactorZero = [UIButton new];
    [self.view addSubview:self.buttonZoomFactorZero];
    [self.buttonZoomFactorZero setImage:[UIImage imageNamed:@"刷新"] forState:UIControlStateNormal];
    [self.buttonZoomFactorZero mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(24);
        make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(-24);
    }];

    self.buttonZoomFactorDowner = [UIButton new];
    [self.view addSubview:self.buttonZoomFactorDowner];
    [self.buttonZoomFactorDowner setImage:[UIImage imageNamed:@"减"] forState:UIControlStateNormal];
    [self.buttonZoomFactorDowner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.buttonZoomFactorZero);
        make.bottom.equalTo(self.buttonZoomFactorZero.mas_top).offset(-24);
    }];

    self.buttonZoomFactorUpper = [UIButton new];
    [self.view addSubview:self.buttonZoomFactorUpper];
    [self.buttonZoomFactorUpper setImage:[UIImage imageNamed:@"加"] forState:UIControlStateNormal];
    [self.buttonZoomFactorUpper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.buttonZoomFactorDowner);
        make.bottom.equalTo(self.buttonZoomFactorDowner.mas_top).offset(-24);
    }];

    [self.buttonTorch addTarget:self action:@selector(buttonTorchClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonTorchDarker addTarget:self action:@selector(buttonTorchDarkerClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonTorchLighter addTarget:self action:@selector(buttonTorchLighterClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonZoomFactorZero addTarget:self action:@selector(buttonZoomFactorZeroClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonZoomFactorDowner addTarget:self action:@selector(buttonZoomFactorDownerClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonZoomFactorUpper addTarget:self action:@selector(buttonZoomFactorUpperClick:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)buttonTorchClick:(UIButton *)sender {
    [self.scanConfig setTorch:!self.scanConfig.isTorch];
    sender.selected = self.scanConfig.isTorch;
}

- (void)buttonTorchDarkerClick:(UIButton *)sender {
    self.scanConfig.torch = self.scanConfig.torch - .1;
    self.buttonTorch.selected = self.scanConfig.isTorch;
}

- (void)buttonTorchLighterClick:(UIButton *)sender {
    self.scanConfig.torch = self.scanConfig.torch + .1;
    self.buttonTorch.selected = self.scanConfig.isTorch;
}

- (void)buttonZoomFactorZeroClick:(UIButton *)sender {
    [self.scanConfig setVideoZoomFactorIdentity];
}
- (void)buttonZoomFactorDownerClick:(UIButton *)sender {
    [self.scanConfig setVideoZoomFactor:self.scanConfig.videoZoomFactor - .5];
}

- (void)buttonZoomFactorUpperClick:(UIButton *)sender {
    [self.scanConfig setVideoZoomFactor:self.scanConfig.videoZoomFactor + .5];
}

- (void)dealloc {
    NSLog(@"dealloc:%s", __FUNCTION__);
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
