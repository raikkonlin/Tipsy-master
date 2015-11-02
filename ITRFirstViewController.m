//
//  ViewController.m
//  ITRAirSideMenu
//
//  Created by kirthi on 11/08/15.
//  Copyright (c) 2015 kirthi. All rights reserved.
//

#import "ITRFirstViewController.h"
#import "ITRAirSideMenu.h"
#import "AppDelegate.h"

@interface ITRFirstViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *subImage1;
@property (weak, nonatomic) IBOutlet UIImageView *subImage2;
@property (weak, nonatomic) IBOutlet UIImageView *subImage3;
@property (weak, nonatomic) IBOutlet UIImageView *subImage4;
@property (weak, nonatomic) IBOutlet UIImageView *subImage5;
@property (weak, nonatomic) IBOutlet UIImageView *subImage6;

@end

@implementation ITRFirstViewController


+ (instancetype) controller{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ITRFirstViewController class])];
}

#pragma view lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

        //隱藏status bar
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:YES withAnimation:YES];


    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu-bgI"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController)];
        //menu照片的顏色受leftBarButtonItem.tintColor控制
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];

    self.mainImage.image = [UIImage imageNamed:@"Dancing-100.png"];
    self.subImage1.image = [UIImage imageNamed:@"Bar-100.png"];
    self.subImage2.image = [UIImage imageNamed:@"Taxi-100.png"];
    self.subImage3.image = [UIImage imageNamed:@"DJ-100.png"]; //Event
    self.subImage4.image = [UIImage imageNamed:@"Profile-100.png"]; //Profile
    self.subImage5.image = [UIImage imageNamed:@"Meeting-100.png"];
    self.subImage6.image = [UIImage imageNamed:@"Settings-100.png"];

}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void) presentLeftMenuViewController{
    
    //show left menu with animation
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
    
}

@end
