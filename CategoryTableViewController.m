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


    UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:100];
    imageView.image = nil;

    NSDictionary *metaData = self.tipsyMetadata[indexPath.row];

    UILabel *label = (UILabel*) [cell.contentView viewWithTag:200];
//    label.text = metaData[@"name"];
    label.text = [metaData objectForKey:@"name"];
    label.textColor = [UIColor clearColor];
    [label setFont:[UIFont systemFontOfSize:35]];

//    NSArray *img_list = metaData[@"yelp_image"];   //有多張圖的網址的話 可以用陣列存網址

            if ( [metaData[@"photo"] isEqual: [NSNull null]] ) {

                cell.imageView.image = [UIImage imageNamed:@"DJ"];

            } else {

                    // 取得陣列 img_list 裡的第一個縮圖網址，轉為 NSURLRequest
                NSString *imgUrlString = metaData[@"photo"];
                NSURL *url = [NSURL URLWithString:imgUrlString];

//                    NSLog(@"url=%@",metaData[@"yelp_image"]);
//                NSLog(@"url=%@",url);
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
//                                NSLog(@"request=%@",request);


                __weak UITableView *weakTableView = tableView;
                __weak UITableViewCell *weakCell = cell;
//                __weak UIImageView *weakImageView = cell.imageView;
                [cell.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {

//                    UIImageView *weakImageView = [[UIImageView alloc] init];
//                    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//                    NSLog(@"%f",(double)width);
//                    CGFloat height = [UIScreen mainScreen].bounds.size.height;
//                    NSLog(@"%f",(double)height);
//                    weakImageView.frame=CGRectMake(0, 0, width, (height-44)/2);
                UIImageView *weakImageView = (UIImageView*)[weakCell.contentView viewWithTag:100];
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

    return cell;
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
