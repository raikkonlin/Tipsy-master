//
//  APPChildViewController.h
//  testt
//
//  Created by pp1285 on 2015/10/23.
//  Copyright © 2015年 EthanChou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppViewController.h"

@interface APPChildViewController : UIViewController<UIPageViewControllerDataSource>
- (IBAction)dismissBut:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UILabel *screenNumber;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSArray *APIarray;
@property (strong, nonatomic) IBOutlet UIImageView *BackGroundImage;

@end
