//
//  LeftMenuController.m
//  ITRAirSideMenu
//
//  Created by kirthi on 12/08/15.
//  Copyright (c) 2015 kirthi. All rights reserved.
//

#import "ITRLeftMenuController.h"
#import "ITRFirstViewController.h"
#import "ITRSecondViewController.h"
#import "AppDelegate.h"
#import "ITRAirSideMenu.h"
#import "CategoryTableViewController.h"
#import "TaxiTableViewController.h"
//#import "StoreTableViewController.h"
#import "AppViewController.h"
#import "TaxiCollectionViewController.h"
#import "StorePFQueryVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "QRCodeViewController.h"
#import "AppViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "EventViewController.h"
#import "DJViewController.h"

@interface ITRLeftMenuController () <ITRAirSideMenuDelegate>
{
    NSIndexPath *selectedIndexPath;
    NSUserDefaults *userDefault;
    NSDictionary *picture;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLogo;

@end

@implementation ITRLeftMenuController


+ (instancetype) controller{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ITRLeftMenuController class])];
}

#pragma view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageViewLogo.image = [UIImage imageNamed:@"Tipsy"];

//    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];

    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.frame = CGRectMake(0, self.view.bounds.size.height-160, self.view.bounds.size.width-130, 50);
//    [loginButton setTitle:@"臉書登入啦" forState:UIControlStateNormal];
    [self.view addSubview:loginButton];

    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];

    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];


    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fbTokenChangeNoti:)
                                                 name:FBSDKAccessTokenDidChangeNotification object:nil];
}

-(void)fbTokenChangeNoti:(NSNotification*)noti {

    userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[FBSDKProfile currentProfile].name forKey:@"userName"];
    [userDefault setObject:[FBSDKProfile currentProfile].userID forKey:@"userID"];

    NSLog(@"User name: %@",[FBSDKProfile currentProfile].name);
    NSLog(@"User ID: %@",[FBSDKProfile currentProfile].userID);

//    NSDictionary *picture = [[NSDictionary alloc] init];

    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                       parameters:@{@"fields": @"name,id,picture,gender,birthday,email"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection
                                  *connection, id result, NSError *error) {
         if (!error) {
//             NSLog(@"fetched user:%@", result);
             picture = result;

//              NSLog(@"fetched user:%@", picture);
         } }];

    if ([FBSDKAccessToken currentAccessToken]) {

        FBSDKAccessToken *fbAccessToken = [FBSDKAccessToken currentAccessToken];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *token = fbAccessToken.tokenString;
        NSString *uid = fbAccessToken.userID;
        [manager POST:@"http://www.pa9.club/api/v1/login" parameters:@{@"access_token":token,@"uid":uid} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON:%@",responseObject);
                //NSString *message = responseObject[@"message"];
            NSString *loginToken = responseObject[@"auth_token"];
//            userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:loginToken forKey:@"loginToken"];
            NSLog(@"%@",loginToken);
            [userDefault synchronize];




        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
              }];
    }
    else{
   /*
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithPublishPermissions:@[@"publish_actions"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error) {
                    // Process error
            } else if (result.isCancelled) {
                    // Handle cancellations
            } else {
                    // If you ask for multiple permissions at once, you
                    // should check if specific permissions missing
                if ([result.grantedPermissions containsObject:@"publish_actions"]) {
                        // Do work

                    [login logInWithReadPermissions:@[@"user_likes",@"user_birthday"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                        if (error) {
                                // Process error
                        } else if (result.isCancelled) {
                                // Handle cancellations
                        } else {
                                // If you ask for multiple permissions at once, you
                                // should check if specific permissions missing
                            if ([result.grantedPermissions containsObject:@"user_birthday"]) {
                                    // Do work

                                NSLog(@"Permission  2: %@",result.grantedPermissions);
                            }
                        }
                    }];

                }
            }
        }];*/
        
    }
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    itrSideMenu.delegate = self;
    //update content view controller with setContentViewController
    [itrSideMenu hideMenuViewController];
    selectedIndexPath = indexPath;

    UIButton *button  = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 60, [self tableView:tableView heightForRowAtIndexPath:indexPath])];
    [tableView addSubview:button];

    [button setShowsTouchWhenHighlighted:YES];

}

- (void)sideMenu:(ITRAirSideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController{
    
    if (selectedIndexPath.row == 0) {
        [sideMenu setContentViewController:[[UINavigationController alloc] initWithRootViewController:[EventViewController controller]]];
    }else if (selectedIndexPath.row == 1){
        
        [sideMenu setContentViewController:[[UINavigationController alloc] initWithRootViewController:[CategoryTableViewController controller]]];
    }
    else if (selectedIndexPath.row == 2){

        [sideMenu setContentViewController:[[UINavigationController alloc] initWithRootViewController:[DJViewController controller]]];
    }
    else if (selectedIndexPath.row == 3){
        
        [sideMenu setContentViewController:[[UINavigationController alloc] initWithRootViewController:[QRCodeViewController controller]]];
    }
//    else if (selectedIndexPath.row == 4){
//
//        [sideMenu setContentViewController:[[UINavigationController alloc] initWithRootViewController:[TaxiCollectionViewController controller]]];
//    }

}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark -
#pragma mark UITableView Datasource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

//    NSDictionary *viewsDictionary =
//    NSDictionaryOfVariableBindings(cell);
//    [self.view addConstraints:[NSLayoutConstraint
//                               constraintsWithVisualFormat:@"H:|-50-[cell]"
//                               options:0
//                               metrics:nil
//                               views:viewsDictionary]];
//    [self.view addSubview:cell];
//    cell.translatesAutoresizingMaskIntoConstraints = NO;

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];



        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
        cell.selectedBackgroundView = [[UIView alloc] init];

        NSArray *titles = @[@"Events", @"Clubs", @"DJs", @"VIP"];
        NSArray *imgArray = @[@"Planner",@"Bar",@"DJ",@"VIP"];
//      cell.imageView.frame = CGRect(100, 100);
        cell.imageView.image = [UIImage imageNamed:imgArray[indexPath.row]];
//      [cell.contentView addSubview:imageView];

        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
        cell.textLabel.text = titles[indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
//      [cell.contentView addSubview:label];

//    [cell addSubview:button];
    /*
    [cell.contentView.layer setBorderColor:[UIColor blackColor].CGColor];
    [cell.contentView.layer setBorderWidth:2.0f];
    */
    
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


-(void)viewDidAppear:(BOOL)animated{


}
@end
