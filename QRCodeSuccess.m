//
//  QRCodeSuccess.m
//  ProjTipsy
//
//  Created by LINCHUNGYAO on 2015/11/5.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import "QRCodeSuccess.h"
#import  <AudioToolbox/AudioToolbox.h>

@interface QRCodeSuccess ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewVIP;

@end

@implementation QRCodeSuccess

-(void)viewDidLoad{

    [super viewDidLoad];


   self.imageViewVIP.frame = self.view.bounds;
    self.imageViewVIP.image = [UIImage imageNamed:@"vip pass"];
    self.imageViewVIP.contentMode = UIViewContentModeScaleToFill;
    self.imageViewVIP.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.imageViewVIP.clipsToBounds = YES;
    self.imageViewVIP.layer.borderColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0].CGColor;
    self.imageViewVIP.layer.borderWidth = 2.0f;


    self.imageView.image = [UIImage imageNamed:@"Tipsy"];

    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

}

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

    UIImage *backgroundImage = [UIImage imageNamed:@"menu_bg"];
    UIImageView *backgroundImageView=[[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];

        //    self.navigationItem.title = @"My Title";
        //    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor yellowColor]};
        ////    [self.navigationItem.title setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:20]];


}

-(void)backButtonPressed{
    [self dismissViewControllerAnimated:NO completion:nil];
}


@end
