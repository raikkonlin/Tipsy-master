//
//  ITRSecondViewController.m
//  ITRAirSideMenu
//
//  Created by kirthi on 12/08/15.
//  Copyright (c) 2015 kirthi. All rights reserved.
//

#import "ITRSecondViewController.h"
#import "ITRAirSideMenu.h"
#import "AppDelegate.h"

@interface ITRSecondViewController ()

@end

@implementation ITRSecondViewController


+ (instancetype) controller{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ITRSecondViewController class])];
}

#pragma view lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    UINavigationBar *navBar = [UINavigationBar appearance];
//        UIColor *blue = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:1.0];
//            // 或是用 UIColor *blueColor = [UIColor blueColor]; 也可以
//        navBar.tintColor = blueColor;
//隱藏status bar
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:YES withAnimation:YES];


    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_bg"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController)];
        //menu照片的顏色受leftBarButtonItem.tintColor控制
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
}

- (void) presentLeftMenuViewController{
    
    //show left menu with animation
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
