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

@interface ITRLeftMenuController ()<ITRAirSideMenuDelegate>
{
    NSIndexPath *selectedIndexPath;
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
        [sideMenu setContentViewController:[[UINavigationController alloc] initWithRootViewController:[CategoryTableViewController controller]]];
    }else if (selectedIndexPath.row == 1){
        
        [sideMenu setContentViewController:[[UINavigationController alloc] initWithRootViewController:[StorePFQueryVC controller]]];
    }
    else if (selectedIndexPath.row == 2){

        [sideMenu setContentViewController:[[UINavigationController alloc] initWithRootViewController:[TaxiTableViewController controller]]];
    }
    else if (selectedIndexPath.row == 3){
        
        [sideMenu setContentViewController:[[UINavigationController alloc] initWithRootViewController:[TaxiTableViewController controller]]];
    }
    else if (selectedIndexPath.row == 4){

        [sideMenu setContentViewController:[[UINavigationController alloc] initWithRootViewController:[TaxiCollectionViewController controller]]];
    }

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
    return 5;
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

        NSArray *titles = @[@"Event", @"Category", @"DJ", @"VIP", @"Vicinity"];
        NSArray *imgArray = @[@"Planner",@"Bar",@"DJ",@"VIP",@"MapMarker"];
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

@end
