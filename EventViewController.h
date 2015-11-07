//
//  EventViewController.h
//  ProjTipsy
//
//  Created by pp1285 on 2015/11/2.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventViewController : UIViewController<UIScrollViewDelegate>
+ (instancetype) controller;
@property (nonatomic) NSMutableArray *APITitlearray;
@property (nonatomic) NSMutableArray *APIImagearray;
-(void)getAPIdata;
//- (IBAction)partyDetailPressed:(UIButton *)sender;


@end
