//
//  QRCodeViewController.m
//  ProjTipsy
//
//  Created by LINCHUNGYAO on 2015/11/2.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import "QRCodeViewController.h"
#import "ITRAirSideMenu.h"
#import "AppDelegate.h"
#import "QRCodeScanVC.h"

@interface QRCodeViewController (){

    BOOL hasVIPService ;

}
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;

@end


@implementation QRCodeViewController

+ (instancetype) controller{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([QRCodeViewController class])];
}



-(void)viewDidLoad{

    [super viewDidLoad];
    hasVIPService = YES;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.width;
    UILabel *labelNotice = [[UILabel alloc] init];

    if (!hasVIPService) {
       labelNotice.frame = CGRectMake(width/2 - 130, height/2 + 150 , 300, 35);

       labelNotice.text = @"You don't have VIP services!!";
       labelNotice.textColor = [UIColor whiteColor];
        [self.view addSubview:labelNotice];
    }
    else{


        labelNotice.frame = CGRectMake(width/4 - 10, height/2 -55, 300, 35);
        labelNotice.text = @"Use QRCode To be a King!!";
        labelNotice.textColor = [UIColor whiteColor];
        [self.view addSubview:labelNotice];

    }

    self.qrCodeImageView.image = [UIImage imageNamed:@"qrcode.png"];

    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:YES withAnimation:YES];

//    CGFloat width = [UIScreen mainScreen].bounds.size.width;

    UINavigationBar *naviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, width, 44)];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController)];
        //menu照片的顏色受leftBarButtonItem.tintColor控制
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];

    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem
                                                alloc] initWithTitle:@"Scan QRCode"
                                               style:UIBarButtonItemStylePlain target:self
                                               action:@selector(scanQRCodeButtonPressed)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];

        //使_UIBackdropView的顏色變成透明
//    [naviBar setBackgroundImage:[UIImage new]
//                  forBarMetrics:UIBarMetricsDefault];
//    naviBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    naviBar.translucent = YES;
    naviBar.backgroundColor = [UIColor clearColor];

    [self.view addSubview:naviBar];

        //************************************************
    UIImage *backgroundImage = [UIImage imageNamed:@"menu_bg"];
    UIImageView *backgroundImageView=[[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
        //***********************************************
}

- (void) presentLeftMenuViewController{

        //show left menu with animation
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];

}

-(void)scanQRCodeButtonPressed{

    QRCodeScanVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"QRCodeScanVC"];

    [self presentViewController:controller animated:NO completion:nil];

   
}


@end
