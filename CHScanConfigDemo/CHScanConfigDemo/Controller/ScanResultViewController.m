//
//  ScanResultViewController.m
//  CHScanConfigDemo
//
//  Created by 张晨晖 on 2019/4/3.
//  Copyright © 2019 张晨晖. All rights reserved.
//

#import "ScanResultViewController.h"
#import <Masonry.h>

@interface ScanResultViewController ()

@property (nonatomic ,strong) UILabel *labelTitle;

@end

@implementation ScanResultViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"扫描结果";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.labelTitle = [[UILabel alloc] init];
    self.labelTitle.numberOfLines = 0;
    [self.view addSubview:self.labelTitle];
    [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide).offset(22);
        make.left.offset(13);
        make.right.lessThanOrEqualTo(@-13);
    }];
    self.labelTitle.text = self.titleStr;
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
