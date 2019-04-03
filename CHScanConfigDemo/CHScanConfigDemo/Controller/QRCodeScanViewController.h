//
//  QRCodeScanViewController.h
//  CHScanConfigDemo
//
//  Created by 张晨晖 on 2019/4/3.
//  Copyright © 2019 张晨晖. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CHScanConfig;
@interface QRCodeScanViewController : UIViewController

@property (nonatomic ,assign) CHScanType scanType;

@end

NS_ASSUME_NONNULL_END
