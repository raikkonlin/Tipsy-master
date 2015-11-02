//
//  TaxiTableViewController.m
//  test1021
//
//  Created by pp1285 on 2015/10/21.
//  Copyright © 2015年 EthanChou. All rights reserved.
//

#import "TaxiTableViewController.h"
#import "TaxiTableViewCell.h"
#import "TaxiButtonView.h"
#import "ITRAirSideMenu.h"
#import "AppDelegate.h"
#import "AFNetworking.h"


@interface TaxiTableViewController (){
    NSArray *locationarray;

}

@end

@implementation TaxiTableViewController
+ (instancetype) controller{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TaxiTableViewController class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"menu_bg"]];
    locationarray = @[@"全台", @"有特色", @"女性" ];
    
    NSLog(@"%d", locationarray.count);
    
    //隱藏status bar
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:YES withAnimation:YES];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_bg"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController)];
    //menu照片的顏色受leftBarButtonItem.tintColor控制
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void) presentLeftMenuViewController{
    
    //show left menu with animation
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return locationarray.count+1  ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    TaxiTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row > 0) {
        Cell.TaxiLocation.text = locationarray[indexPath.row-1];

    }
    Cell.TaxiLocation.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    Cell.TaxiLocation.textColor = [UIColor whiteColor];
    UINib *nib = [UINib nibWithNibName:@"TaxiButtonView" bundle:nil];
    NSArray *array = [nib instantiateWithOwner:nil options:nil];
    NSArray *arr = [nib instantiateWithOwner:nil options:nil];
    TaxiButtonView *targetView = array[0];
    
    targetView.frame = CGRectOffset(targetView.frame, 20, 35);
    targetView.layer.cornerRadius = 5;
    targetView.backgroundColor = [UIColor clearColor];
    targetView.layer.borderColor = [UIColor yellowColor].CGColor;
    targetView.layer.borderWidth = 1;
    TaxiButtonView *targetView2 = arr[0];
    targetView2.frame = CGRectOffset(targetView2.frame, 120, 35);
    targetView2.layer.cornerRadius = 5;
    targetView2.backgroundColor = [UIColor clearColor];
    targetView2.layer.borderColor = [UIColor yellowColor].CGColor;
    targetView2.layer.borderWidth = 1;


    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(80, 40, 500, 50)];
    switch (indexPath.row) {
        case 1:
            targetView.TaxiName.text = @"阿斯拉";
            [targetView.taxiPhoneNumber setTitle:@"12345" forState:UIControlStateNormal];
            [Cell.contentView addSubview:targetView];
            break;
        case 2:
            targetView.TaxiName.text = @"哥吉拉";
            [targetView.taxiPhoneNumber setTitle:@"2345" forState:UIControlStateNormal];
            [Cell.contentView addSubview:targetView];
            
            targetView2.TaxiName.text = @"派大星";
            [targetView2.taxiPhoneNumber setTitle:@"334567" forState:UIControlStateNormal];
            [Cell.contentView addSubview:targetView2];
            break;
        case 3:
            targetView.TaxiName.text = @"阿不拉";
            [targetView.taxiPhoneNumber setTitle:@"2345" forState:UIControlStateNormal];
            [Cell.contentView addSubview:targetView];
            targetView2.TaxiName.text = @"派大星球";
            [targetView2.taxiPhoneNumber setTitle:@"334567" forState:UIControlStateNormal];
            [Cell.contentView addSubview:targetView2];
            break;
        case 0:
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
            label.text = @"將計程車設為我的最愛";
            [Cell.contentView addSubview:label];
            break;
        default:
            break;
    }
    

    

    
    
    return Cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
