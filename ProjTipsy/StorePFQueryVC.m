    //
    //  StorePFQueryVC.m
    //  ProjTipsy
    //
    //  Created by LINCHUNGYAO on 2015/10/30.
    //  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
    //

#import "StorePFQueryVC.h"
#import "ITRAirSideMenu.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "ShowDescriptionVC.h"

@interface StorePFQueryVC ()

@end


@implementation StorePFQueryVC

+ (instancetype) controller{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([StorePFQueryVC class])];
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
            // Custom the table

            // The className to query on
        self.parseClassName = @"Store";

            // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"storename";

            // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;

            // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;

            // The number of objects to show per page
            //self.objectsPerPage = 10;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        //隱藏status bar
    UIApplication *app = [UIApplication sharedApplication];

    [app setStatusBarHidden:YES withAnimation:YES];


            self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_bg"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController)];

        //menu照片的顏色受leftBarButtonItem.tintColor控制
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];



        //    [[NSNotificationCenter defaultCenter] addObserver:self
        //                                             selector:@selector(refreshTable:)
        //                                                 name:@"refreshTable"
        //                                               object:nil];
}

- (void) presentLeftMenuViewController{

        //show left menu with animation
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;

    [itrSideMenu presentLeftMenuViewController];

}

    //- (void)refreshTable:(NSNotification *) notification
    //{
    //        // Reload the recipes
    //    [self loadObjects];
    //}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
        //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshTable" object:nil];
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];

        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }

        //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        //    NSDate *comparingDate = [dateFormatter dateFromString:@"2015-10-04"];
        //    [query whereKey:@"date" greaterThan:comparingDate];
        //    [query orderByDescending:@"date"];


    return query;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"parseReuseId";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

        //    cell.backgroundColor = [UIColor clearColor];

        // Configure the cell
    PFFile *thumbnail = [object objectForKey:@"storePics"];
    PFImageView *thumbnailImageView = (PFImageView*)[cell.contentView viewWithTag:50];
    thumbnailImageView.image = [UIImage imageNamed:@"placeholder.png"];
    thumbnailImageView.file = thumbnail;
    thumbnailImageView.layer.cornerRadius = 0; //thumbnailImageView.frame.size.width / 2;
    thumbnailImageView.layer.masksToBounds = YES;
    thumbnailImageView.contentMode = UIViewContentModeScaleToFill;
        //    thumbnailImageView.layer.borderWidth = 1.0f;
        //    thumbnailImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [thumbnailImageView loadInBackground];

    UILabel *storeNameLabel = (UILabel*) [cell.contentView viewWithTag:51];
    storeNameLabel.text = [object objectForKey:@"storename"];
    storeNameLabel.textColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
    [storeNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:24]];

    UILabel *descriptionLabel = (UILabel*) [cell.contentView viewWithTag:52];
    descriptionLabel.text = [object objectForKey:@"description"];
    descriptionLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];

    UILabel *addressLabel = (UILabel*) [cell.contentView viewWithTag:53];
    addressLabel.text = [object objectForKey:@"address"];
    addressLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [addressLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:10]];

    UILabel *distanceDate = (UILabel*) [cell.contentView viewWithTag:55];
//    distanceDate.text =  [[object objectForKey:@"evnetPicNumber"] intValue];
    distanceDate.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [distanceDate setFont:[UIFont fontWithName:@"HelveticaNeue" size:0]];

    UILabel *updateDate = (UILabel*) [cell.contentView viewWithTag:54];
    updateDate.text = [object objectForKey:@"updateDate"];
    updateDate.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [updateDate setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];

    UIButton *GeoPositionButton = (UIButton*) [cell.contentView viewWithTag:56];
        //    addressButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Marker-50"]];
        //    [addressButton setBackgroundImage:[UIImage imageNamed:@"Marker-50"] forState:UIControlStateNormal];

    UILabel *labelLike = (UILabel*) [cell.contentView viewWithTag:57];
    labelLike.text = [object objectForKey:@"Like"];
    labelLike.textColor = [UIColor colorWithRed:51/255.0 green:152/255.0 blue:219/255.0 alpha:1.0];
    [labelLike setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    labelLike.layer.cornerRadius = labelLike.frame.size.width/2;
    labelLike.layer.borderWidth = 1.0f;
    labelLike.layer.borderColor = [UIColor colorWithRed:51/255.0 green:152/255.0 blue:219/255.0 alpha:1.0].CGColor;
    labelLike.layer.masksToBounds = YES;


        //setup background image-------------------------------
    UIImage *backgroundImage = [UIImage imageNamed:@"menu_bg"];
    UIImageView *backgroundImageView=[[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    [cell insertSubview:backgroundImageView atIndex:0];
        //end of setting up background image-------------------

    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

     /*
     ShowDescriptionVC *controllerEvent = [[ShowDescriptionVC alloc] init];
     controllerEvent = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowDescriptionVC"];
     UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controllerEvent];
     */

    ShowDescriptionVC *controllerEvent = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowDescriptionVC"];

    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    controllerEvent.storeName = [object objectForKey:@"storename"];
    controllerEvent.objectID = [object objectId];


//    UILabel *storeNameLabel = [[UILabel alloc] init];
//    storeNameLabel.text = [object objectForKey:@"storename"];
//    NSLog(@"%@",storeNameLabel.text);

//        // 設定date的格式後再傳
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"yyy-MM-dd"];
//    NSString *dateString = [df stringFromDate:[object objectForKey:@"date"]];
//    controllerEvent.dateTime = dateString;


    controllerEvent.imageFile1 = [object objectForKey:@"Picture1"];
    controllerEvent.imageFile2 = [object objectForKey:@"Picture2"];
    controllerEvent.imageFile3 = [object objectForKey:@"Picture3"];
    controllerEvent.likeLabel  = [object objectForKey:@"Like"];
    
    [self presentViewController:controllerEvent animated:NO completion:nil];
    
}


//- (void) objectsDidLoad:(NSError *)error
//{
//    [super objectsDidLoad:error];
//    
//    NSLog(@"error: %@", [error localizedDescription]);
//}

@end
