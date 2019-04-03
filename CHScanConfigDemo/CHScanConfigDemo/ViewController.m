//
//  ViewController.m
//  CHScanConfigDemo
//
//  Created by 张晨晖 on 2019/4/1.
//  Copyright © 2019 张晨晖. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeScanViewController.h"
#import "CreatCodeImageViewController.h"
#import "CheckQRCodeViewController.h"

@interface ViewController () <UITableViewDataSource ,UITableViewDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSArray <NSString *> *titleArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];

    self.titleArray = @[@"扫描QRCode" ,@"扫描条码" ,@"扫描二维码" ,@"扫描二维码与条码" ,@"生成QRCode" ,@"生成条形码" ,@"生成PDF417" ,@"生成aztec" ,@"检测图片中的二维码"];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{//扫描QRCode
            QRCodeScanViewController *vc = [[QRCodeScanViewController alloc] init];
            vc.scanType = CHScanTypeQRCode;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{//扫描条码
            QRCodeScanViewController *vc = [[QRCodeScanViewController alloc] init];
            vc.scanType = CHScanTypeBarCode;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{//扫描二维码
            QRCodeScanViewController *vc = [[QRCodeScanViewController alloc] init];
            vc.scanType = CHScanType2DCode;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{//扫描二维码与条码
            QRCodeScanViewController *vc = [[QRCodeScanViewController alloc] init];
            vc.scanType = CHScanTypeCommon;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:{//生成QRCode
            CreatCodeImageViewController *vc = [[CreatCodeImageViewController alloc] init];
            vc.codeType = 0;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:{//生成条形码
            CreatCodeImageViewController *vc = [[CreatCodeImageViewController alloc] init];
            vc.codeType = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:{//生成PDF417
            CreatCodeImageViewController *vc = [[CreatCodeImageViewController alloc] init];
            vc.codeType = 2;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:{//生成aztec
            CreatCodeImageViewController *vc = [[CreatCodeImageViewController alloc] init];
            vc.codeType = 3;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 8:{//检测图片中的二维码
            CheckQRCodeViewController *vc = [[CheckQRCodeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        default:
            break;
    }
}

@end
