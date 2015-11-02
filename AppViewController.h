//
//  AppViewController.h
//  testt
//
//  Created by pp1285 on 2015/10/23.
//  Copyright © 2015年 EthanChou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPChildViewController.h"

@interface AppViewController : UIViewController<UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageController;
+ (instancetype) controller;
@property (nonatomic) NSMutableArray *APITitlearray;
@property (nonatomic) NSMutableArray *APIImagearray;
-(void)getAPIdata;

@property(nonatomic,assign,getter=isTranslucent)BOOL translucent;

@end
