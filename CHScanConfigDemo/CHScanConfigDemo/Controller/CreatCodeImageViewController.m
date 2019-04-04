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

@property (nonatomic ,strong) UIButton *buttonSave;

@end

@implementation CreatCodeImageViewController

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

    self.buttonSave = [[UIButton alloc] init];
    self.buttonSave.backgroundColor = [UIColor colorWithWhite:.6 alpha:1];
    self.buttonSave.contentEdgeInsets = UIEdgeInsetsMake(6, 8, 6, 8);
    [self.buttonSave setTitle:@"保存到相册" forState:UIControlStateNormal];
    [self.view addSubview:self.buttonSave];
    [self.buttonSave mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.textField.mas_top).offset(-8);
        make.centerX.equalTo(self.view);
    }];

    /// 生成码
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide).offset(0);
        make.left.right.offset(0);
        make.bottom.equalTo(self.buttonSave.mas_top).offset(-8);
    }];

    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonSave addTarget:self action:@selector(buttonSaveClick:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)buttonSaveClick:(UIButton *)sender {
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *title = error?@"保存图片失败":@"保存图片成功";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
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
