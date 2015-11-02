//
//  APPChildViewController.m
//  testt
//
//  Created by pp1285 on 2015/10/23.
//  Copyright © 2015年 EthanChou. All rights reserved.
//

#import "APPChildViewController.h"
#import "UIImageView+AFNetworking.h"
#import "EventDetailTableViewController.h"

@interface APPChildViewController ()

@end

@implementation APPChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s", __FUNCTION__);
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addMovieNoti:) name:@"AddMovieNoti" object:nil];
    AppViewController *controller = [[self parentViewController] parentViewController];
    

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_bg"]];


    self.screenNumber.text = [NSString stringWithFormat:@"%@", controller.APITitlearray[self.index]];
    self.BackGroundImage.image = controller.APIImagearray[self.index];

//    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
//    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
//    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];

//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = NO;

}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"%s", __FUNCTION__);

}
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"%s", __FUNCTION__);

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    
    return self;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)addMovieNoti:(NSNotification *)noti{
    //notiiiii
    NSDictionary *imageDic = noti.userInfo;
    AppViewController *controller = [[self parentViewController] parentViewController];
    [controller.APIImagearray addObject: imageDic[@"image"]];
    self.BackGroundImage.image = controller.APIImagearray[self.index];

}
- (IBAction)dismissBut:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EventDetailTableViewController *controller =  [storyboard instantiateViewControllerWithIdentifier:@"EventDetailTableViewController"];
    [self presentViewController:controller animated:YES completion:nil];
    
}
@end
