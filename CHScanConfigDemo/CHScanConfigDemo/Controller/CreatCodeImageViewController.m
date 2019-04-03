//
//  CreatCodeImageViewController.m
//  CHScanConfigDemo
//
//  Created by 张晨晖 on 2019/4/3.
//  Copyright © 2019 张晨晖. All rights reserved.
//

#import "CreatCodeImageViewController.h"

@interface CreatCodeImageViewController ()

@property (nonatomic ,strong) UIImageView *imageView;

@property (nonatomic ,strong) UIButton *button;

@property (nonatomic ,strong) UITextField *textField;

@end

@implementation CreatCodeImageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Code生成";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.button = [UIButton new];
    self.button.contentEdgeInsets = UIEdgeInsetsMake(6, 8, 6, 8);
    [self.view addSubview:self.button];
    [self.button setTitle:@"生成" forState:UIControlStateNormal];
    self.button.backgroundColor = [UIColor colorWithWhite:.6 alpha:1];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-8);
        make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(-8);
    }];
    [self.button setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];

    self.textField = [[UITextField alloc] init];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.placeholder = @"输入要生成的文字内容";
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(8);
        make.centerY.equalTo(self.button);
        make.right.equalTo(self.button.mas_left).offset(-8);
    }];
    [self.textField setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

    /// 生成码
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide).offset(0);
        make.left.right.offset(0);
        make.bottom.equalTo(self.textField.mas_top).offset(-8);
    }];

    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClick:(UIButton *)sender {
    NSString *codeString = self.textField.text?self.textField.text:@"";
    switch (self.codeType) {
        case 0:
            /// QRCode
            self.imageView.image = [CHScanConfig creatQRCodeImageWithString:codeString imageSize:CGSizeMake(200, 200)];
            break;
        case 1:
            /// 条形码
            self.imageView.image = [CHScanConfig creatCode128BarCodeImageWithString:codeString imageSize:CGSizeMake(100, 220)];
            break;
        case 2:
            /// PDF417码
            self.imageView.image = [CHScanConfig creatPDF417BarCodeImageWithString:codeString imageSize:CGSizeMake(200, 200)];
            break;
        case 3:
            /// aztec
            self.imageView.image = [CHScanConfig creatAztecCodeImageWithString:codeString imageSize:CGSizeMake(200, 200)];
            break;
        default:
            break;
    }
    [self.textField resignFirstResponder];
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
