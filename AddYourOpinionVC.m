//
//  AddYourOpinionVC.m
//  ProjTipsy
//
//  Created by LINCHUNGYAO on 2015/11/2.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import "AddYourOpinionVC.h"




@implementation AddYourOpinionVC




-(void)viewDidAppear:(BOOL)animated{


    CGFloat width = [UIScreen mainScreen].bounds.size.width;

    UINavigationBar *naviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
    [self.view addSubview:naviBar];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Previous-50"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(backButtonPressed)
                                 ];

    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                style:UIBarButtonItemStylePlain
                                                               target:self action:nil
                                ];

    UINavigationItem  *naviItem = [[UINavigationItem alloc] initWithTitle:@""];

    naviItem.leftBarButtonItem = backItem;
    naviItem.rightBarButtonItem = addItem;
        //        menu照片的顏色受leftBarButtonItem.tintColor控制
    naviItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
    naviBar.items = [NSArray arrayWithObjects:naviItem,nil];

        //使_UIBackdropView的顏色變成透明
    [naviBar setBackgroundImage:[UIImage new]
                  forBarMetrics:UIBarMetricsDefault];
    naviBar.shadowImage = [UIImage new];
    naviBar.translucent = YES;


}

-(void)backButtonPressed{
    [self dismissViewControllerAnimated:NO completion:nil];
}


@end
