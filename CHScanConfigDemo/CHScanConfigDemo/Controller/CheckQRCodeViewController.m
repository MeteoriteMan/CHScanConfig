//
//  CheckQRCodeViewController.m
//  CHScanConfigDemo
//
//  Created by 张晨晖 on 2019/4/3.
//  Copyright © 2019 张晨晖. All rights reserved.
//

#import "CheckQRCodeViewController.h"
#import "ScanResultViewController.h"
#import "CHScanConfig.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface CheckQRCodeViewController () <UINavigationControllerDelegate ,UIImagePickerControllerDelegate>

@property (nonatomic ,strong) UIButton *buttonSelect;

@end

@implementation CheckQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.buttonSelect = [[UIButton alloc] init];
    [self.buttonSelect setTitle:@"选择照片" forState:UIControlStateNormal];
    [self.buttonSelect setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:self.buttonSelect];
    [self.buttonSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    [self.buttonSelect addTarget:self action:@selector(buttonSelectClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonSelectClick:(UIButton *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.navigationBar.translucent = NO;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [CHScanConfig recognizeImage:[info objectForKey:UIImagePickerControllerOriginalImage] resultBlock:^(NSArray<NSString *> *stringValues) {
            ScanResultViewController *vc = [[ScanResultViewController alloc] init];
            vc.titleStr = stringValues.firstObject;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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
