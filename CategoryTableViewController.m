//
//  CategoryTableViewController.m
//  ProjTipsy
//
//  Created by LINCHUNGYAO on 2015/10/21.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "ITRAirSideMenu.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import <SystemConfiguration/SystemConfiguration.h> //檢查連線狀況
#import "CommentsTableVC.h"

@interface CategoryTableViewController ()

@property (nonatomic, strong) NSMutableArray *tipsyMetadata;


@end

@implementation CategoryTableViewController

+ (instancetype) controller{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CategoryTableViewController class])];
}


#pragma view lifecycle
- (void)viewDidLoad {
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




    [self loadTipsyMetadata];


}

- (void) presentLeftMenuViewController{

        //show left menu with animation
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;

    [itrSideMenu presentLeftMenuViewController];

}


-(void)loadTipsyMetadata
{
        //檢查連線狀況
    NSString *host = @"www.apple.com";
    SCNetworkReachabilityRef  reachability =SCNetworkReachabilityCreateWithName(nil, host.UTF8String);
    SCNetworkReachabilityFlags flags;
    BOOL result = NO;
    if(reachability) {
        result = SCNetworkReachabilityGetFlags(reachability, &flags);
        CFRelease(reachability);
    }

     NSLog(@"%d %d", result, flags);

    if(!result || !flags) {
        NSLog(@"無網路");
      }
    else {
       NSLog(@"有網路");
    }

        // 設定類別屬性 hotTexts 的初始大小為 20，用來存抓下來的熱門文章列表
     self.tipsyMetadata= [NSMutableArray arrayWithCapacity:40];

        // 將網址字串轉為 NSURLRequest 物件 request
    NSString *urlString = @"http://www.pa9.club/api/v1/stores";

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

        // 使用 AFNetworking 的類別 AFHTTPRequestOperation 建立物件 operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

        // 設定將傳回的資料從 JSON 轉為 NSDictionary
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

        // 設定 operation 執行成功及失敗後要做什麼
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

            // 將抓回來的資料存成 NSDictionary 的物件 data
        NSDictionary *data = (NSDictionary *) responseObject;

            // 用 NSLog 顯示錯誤訊息
//        NSLog(@"err:%@",data[@"err"]);

        self.tipsyMetadata = data[@"data"];

            // 重新顯示 tableView
        [self.tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // opration 執行失敗的話用 UIAlertView 顯示錯誤訊息
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving TipsyMetadata"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];

    }];
        // 執行 operation
    [operation start];


}


-(void)viewDidAppear:(BOOL)animated {

    [self.tableView reloadData];

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
         NSLog(@"rowCount=%lu",self.tipsyMetadata.count);
    return self.tipsyMetadata.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCellId" forIndexPath:indexPath];

    if ( !cell ) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CategoryCellId"];
    }

    cell.backgroundColor = [UIColor clearColor];

    UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:90];
    imageView.image = nil;

    NSDictionary *metaData = self.tipsyMetadata[indexPath.row];

    UILabel *storeNameLabel = (UILabel*) [cell.contentView viewWithTag:91];

    storeNameLabel.text = [metaData objectForKey:@"name"];
    storeNameLabel.backgroundColor = [UIColor clearColor];
    storeNameLabel.textColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
    [storeNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:24]];

    UILabel *descriptionLabel = (UILabel*) [cell.contentView viewWithTag:92];

    descriptionLabel.text = [metaData objectForKey:@"description"];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.textColor = [UIColor whiteColor];
    [descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:18]];

    UILabel *addressLabel = (UILabel*) [cell.contentView viewWithTag:93];

    addressLabel.text = [metaData objectForKey:@"address"];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.textColor = [UIColor whiteColor];
    [addressLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:10]];

    UILabel *updateDate = (UILabel*) [cell.contentView viewWithTag:94];
    NSString *myString = @"Update: ";
    NSString *test = [myString stringByAppendingString:[metaData objectForKey:@"updated_at"]];
    updateDate.text = test;
    updateDate.backgroundColor = [UIColor clearColor];
    updateDate.textColor = [UIColor whiteColor];
    [updateDate setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:12]];

    UILabel *commentLabel = (UILabel*) [cell.contentView viewWithTag:95];

    NSNumber *message_id = [NSNumber numberWithInt:[[metaData objectForKey:@"comments_count"] intValue]];

    commentLabel.text = [message_id stringValue];
    commentLabel.textColor = [UIColor colorWithRed:51/255.0 green:152/255.0 blue:219/255.0 alpha:1.0];
    [commentLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    commentLabel.layer.cornerRadius = commentLabel.frame.size.width/2;
    commentLabel.layer.borderWidth = 1.0f;
    commentLabel.layer.borderColor = [UIColor colorWithRed:51/255.0 green:152/255.0 blue:219/255.0 alpha:1.0].CGColor;
    commentLabel.layer.masksToBounds = YES;

            if ( [metaData[@"photo"] isEqual: [NSNull null]] ) {

                cell.imageView.image = [UIImage imageNamed:@"DJ"];

            } else {

                    // 取得陣列 img_list 裡的第一個縮圖網址，轉為 NSURLRequest
                NSString *imgUrlString = metaData[@"photo"];
                NSURL *url = [NSURL URLWithString:imgUrlString];

                NSURLRequest *request = [NSURLRequest requestWithURL:url];

                __weak UITableView *weakTableView = tableView;
                __weak UITableViewCell *weakCell = cell;
                [cell.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {

                UIImageView *weakImageView = (UIImageView*)[weakCell.contentView viewWithTag:90];
                weakImageView.image = image;
                weakImageView.contentMode = UIViewContentModeScaleToFill;
                weakImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

                if ([weakTableView.visibleCells containsObject:weakCell]) {

                      [weakTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

                    }

                    [weakCell setNeedsLayout];

                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {

                    NSLog(@"Failed to get image");

                }];

            }

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

    CommentsTableVC *controllerEvent = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentsTableVC"];
/*
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    controllerEvent.storeName = [object objectForKey:@""];
    controllerEvent.objectID = [object objectId];*/
    NSDictionary  *dictEdit = self.tipsyMetadata[indexPath.row];
    NSLog(@"store %@",[dictEdit objectForKey:@"id"]);
    controllerEvent.storeId = [NSString stringWithFormat:@"%@",[dictEdit objectForKey:@"id"]];

        //    UILabel *storeNameLabel = [[UILabel alloc] init];
        //    storeNameLabel.text = [object objectForKey:@"storename"];
        //    NSLog(@"%@",storeNameLabel.text);

        //        // 設定date的格式後再傳
        //    NSDateFormatter *df = [[NSDateFormatter alloc] init];
        //    [df setDateFormat:@"yyy-MM-dd"];
        //    NSString *dateString = [df stringFromDate:[object objectForKey:@"date"]];
        //    controllerEvent.dateTime = dateString;

/*
    controllerEvent.imageFile1 = [object objectForKey:@""];
    controllerEvent.imageFile2 = [object objectForKey:@""];
    controllerEvent.imageFile3 = [object objectForKey:@""];
    controllerEvent.likeLabel  = [object objectForKey:@""];*/

    [self presentViewController:controllerEvent animated:NO completion:nil];

}

-(void)AddEditNotification:(NSNotification *)notification{

    [self.tableView reloadData];

}
@end
