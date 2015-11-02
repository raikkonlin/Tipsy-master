//
//  EventDetailTableViewController.m
//  ProjTipsy
//
//  Created by pp1285 on 2015/10/29.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import "EventDetailTableViewController.h"
#import "AppDelegate.h"
#import "ITRAirSideMenu.h"
#import "EventPicTableViewCell.h"


@implementation EventDetailTableViewController
+(instancetype) controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([EventDetailTableViewController class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor blackColor];
    
    self.EventPicTableViewCell.picScrollView.contentSize = CGSizeMake(4* [UIScreen mainScreen].bounds.size.width /2, self.EventPicTableViewCell.frame.size.height -16 );
    CGRect Frame = CGRectMake(8,8 , [UIScreen mainScreen].bounds.size.width /2,self.EventPicTableViewCell.frame.size.height );
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:Frame];
    imageView.image = [UIImage imageNamed:@"lava"];

    Frame = CGRectMake([UIScreen mainScreen].bounds.size.width /2 +16, 8 , [UIScreen mainScreen].bounds.size.width /2, self.EventPicTableViewCell.frame.size.height);
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:Frame];
        imageView2.image = [UIImage imageNamed:@"lava2"];
    Frame = CGRectMake(2*[UIScreen mainScreen].bounds.size.width /2 +24, 8 , [UIScreen mainScreen].bounds.size.width /2, self.EventPicTableViewCell.frame.size.height);
    
        UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:Frame];
        imageView3.image = [UIImage imageNamed:@"lava3"];
    Frame = CGRectMake(3*[UIScreen mainScreen].bounds.size.width /2 +32, 8 , [UIScreen mainScreen].bounds.size.width /2, self.EventPicTableViewCell.frame.size.height);
    
    UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:Frame];
    imageView4.image = [UIImage imageNamed:@"lava4"];



    [self.EventPicTableViewCell.picScrollView addSubview:imageView];
    [self.EventPicTableViewCell.picScrollView addSubview:imageView2];
    [self.EventPicTableViewCell.picScrollView addSubview:imageView3];
    [self.EventPicTableViewCell.picScrollView addSubview:imageView4];

    
    
    
//    地圖
    locationManager = [[CLLocationManager alloc]init];
    [locationManager requestAlwaysAuthorization];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 8;
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    
//    return cell;
//}


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
- (void) presentLeftMenuViewController{
     
     //show left menu with animation
     ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
     [itrSideMenu presentLeftMenuViewController];
     
 }

- (IBAction)menuButtonPress:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<=0) {
        scrollView.contentOffset = CGPointZero;
    }
}
@end
