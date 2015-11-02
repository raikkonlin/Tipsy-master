//
//  EventDetailViewController.m
//  ProjTipsy
//
//  Created by pp1285 on 2015/10/29.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import "EventDetailViewController.h"
#import "AppDelegate.h"
#import "ITRAirSideMenu.h"

@interface EventDetailViewController ()
- (IBAction)menuButtonPress:(UIButton *)sender;


@end

@implementation EventDetailViewController
+(instancetype) controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([EventDetailViewController class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        
   
//    UINavigationBar *navBar = [UINavigationBar appearance];
//    [navBar setBarTintColor:[UIColor blackColor]];
//    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"]
//                                                                             style:UIBarButtonItemStylePlain
//                                                                            target:self action:@selector(presentLeftMenuViewController)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) presentLeftMenuViewController{
    
    //show left menu with animation
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
    
}

- (IBAction)menuButtonPress:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
