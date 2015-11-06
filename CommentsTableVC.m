//
//  CommentsTableVC.m
//  ProjTipsy
//
//  Created by LINCHUNGYAO on 2015/11/3.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import "CommentsTableVC.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import <SystemConfiguration/SystemConfiguration.h> //檢查連線狀況
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "TextFieldDelegateVC.h"

@interface CommentsTableVC () <UIScrollViewDelegate> {

    __weak UIButton *_buttonToComment;

    NSMutableArray *storeCommentArray;
    NSString *fbUserName;
    NSString *fbUserID;
    NSDictionary *rankingStar;
}

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;


@end


@implementation CommentsTableVC


-(void)viewDidLoad{

    [super viewDidLoad];

    /*
    rankingStar =@{@"1": @"🌟",
                   @"2": @"🌟🌟",
                   @"3": @"🌟🌟🌟",
                   @"4": @"🌟🌟🌟🌟",
                   @"5": @"🌟🌟🌟🌟🌟"};
    */
    

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    fbUserName = [userDefaultes stringForKey:@"userName"];
    fbUserID = [userDefaultes stringForKey:@"userID"];

    NSString *path1 = [@"http://graph.facebook.com/" stringByAppendingString:fbUserID ];
    NSString *path =[path1 stringByAppendingString:@"/picture"];
    [self.userImage setImageWithURL:[NSURL URLWithString:path]];

    /*
    AFHTTPRequestOperationManager *manager =         [AFHTTPRequestOperationManager manager];
    [manager GET:path parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {        ObjectNSLog(@"JSON: %@", responseObject);   } failure:^(AFHTTPRequestOperation *operation, NSError *error) { NSLog(@"Error: %@", error);  }];
     */

//    self.userImage.image = [UIImage imageNamed:@"Jonny.jpg"];
    self.userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userImage.layer.borderWidth =3.0f;
    self.userImage.layer.cornerRadius = self.userImage.frame.size.width/2;
    self.userImage.clipsToBounds = YES;

    
//    self.labelUserName.text = @"Johnny Scrap";
    self.labelUserName.text = fbUserName;
    self.labelUserName.textColor = [UIColor whiteColor];

    UIButton *buttonToComment = [[UIButton alloc] initWithFrame:CGRectMake(0, self.tableView.bounds.size.height-50, self.tableView.bounds.size.width, 50)];
    buttonToComment.backgroundColor = [UIColor clearColor];

    buttonToComment.layer.borderWidth = 2.0f;
    buttonToComment.layer.borderColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0].CGColor;
    [buttonToComment setTitle:@"Add Your Opinion" forState:UIControlStateNormal];
    [buttonToComment setTitleColor:[UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0] forState:UIControlStateNormal];
    [buttonToComment setShowsTouchWhenHighlighted:YES];
    [buttonToComment addTarget:self
                        action:@selector(AddYourOpinionButton)
              forControlEvents:UIControlEventTouchUpInside];
        //    UILabel *labelCom = [[UILabel alloc] init];
        //             labelCom.text = @"Add Your Opinion",
        //    [self.tableView addSubview:labelCom];
    [self.tableView addSubview:buttonToComment];
    _buttonToComment = buttonToComment;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
//    NSLog(@"%@",self.storeId);

    [self loadStoreComments];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AddCommentRefresh:)
                                                 name:@"AddCommentRefresh"
                                               object:nil];

}



-(void)viewDidAppear:(BOOL)animated{

    CGFloat width = [UIScreen mainScreen].bounds.size.width;

    UINavigationBar *naviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
    [self.view addSubview:naviBar];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Previous-50"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(backButtonPressed)
                                 ];

    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                style:UIBarButtonItemStylePlain
                                                               target:self action:nil
                                ];

    UINavigationItem  *naviItem = [[UINavigationItem alloc] initWithTitle:@""];

    naviItem.leftBarButtonItem = backItem;
    naviItem.rightBarButtonItem = addItem;
        //        menu照片的顏色受leftBarButtonItem.tintColor控制
    naviItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
    naviBar.items = [NSArray arrayWithObjects:naviItem,nil];

        //使_UIBackdropView的顏色變成透明
    [naviBar setBackgroundImage:[UIImage new]
                  forBarMetrics:UIBarMetricsDefault];
    naviBar.shadowImage = [UIImage new];
    naviBar.translucent = YES;

    UIImage *backgroundImage = [UIImage imageNamed:@"menu_bg"];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];

    [self.tableView reloadData];
}


-(void)AddYourOpinionButton{

    TextFieldDelegateVC *controllerEvent = [self.storyboard instantiateViewControllerWithIdentifier:@"TextFieldDelegateVC"];

    controllerEvent.storeID = self.storeId;

    [self presentViewController:controllerEvent animated:NO completion:nil];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _buttonToComment.transform = CGAffineTransformMakeTranslation(0, scrollView.contentOffset.y);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
        // this is needed to prevent cells from being displayed above our static view
    [self.tableView bringSubviewToFront:_buttonToComment];
}

-(void)loadStoreComments
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
    storeCommentArray= [NSMutableArray arrayWithCapacity:40];

        // 將網址字串轉為 NSURLRequest 物件 request
    NSString *urlString = @"http://www.pa9.club/api/v1/stores/";
    urlString = [urlString stringByAppendingString:self.storeId];
    NSLog(@"self.storeId %@",self.storeId);
    NSLog(@"%@",urlString);

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

        storeCommentArray = data[@"comment"];
        NSLog(@"data  %@",data[@"comment"]);

            //*** 重新顯示 tableView
        [self.tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // opration 執行失敗的話用 UIAlertView 顯示錯誤訊息
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving storeCommentArray"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }];
        // 執行 operation
    [operation start];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"rowCount=%lu",storeCommentArray.count);
    return storeCommentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentReuseId" forIndexPath:indexPath];

    if ( !cell ) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CommentReuseId"];
    }

    cell.backgroundColor = [UIColor clearColor];

    UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:90];

    imageView.image = nil;

    NSDictionary *metaData = storeCommentArray[indexPath.row];

    UILabel *ratingNameLabel = (UILabel*) [cell.contentView viewWithTag:111];

    NSLog(@"store %@",[metaData objectForKey:@"rating"]);
    NSString *tempString = [[NSString alloc] init];
    tempString = [NSString stringWithFormat:@"%@", [metaData objectForKey:@"rating"]];

    if ([tempString isEqualToString:@"1"]) {

        tempString = @"🎉";
    }else if ([tempString isEqualToString:@"2"]){

        tempString = @"🎉🎉";
    }else if ([tempString isEqualToString:@"3"]){

        tempString = @"🎉🎉🎉";
    }else if ([tempString isEqualToString:@"4"]){

        tempString = @"🎉🎉🎉🎉";
    }else if ([tempString isEqualToString:@"5"]){

        tempString = @"🎉🎉🎉🎉🎉";
    }
    ratingNameLabel.text = tempString;
    ratingNameLabel.backgroundColor = [UIColor clearColor];
    ratingNameLabel.textColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
    [ratingNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:24]];

    UILabel *contentionLabel = (UILabel*) [cell.contentView viewWithTag:112];

    contentionLabel.text = [metaData objectForKey:@"content"];
    contentionLabel.backgroundColor = [UIColor clearColor];
    contentionLabel.textColor = [UIColor whiteColor];
    [contentionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:18]];

    UILabel *userLabel = (UILabel*) [cell.contentView viewWithTag:113];

    userLabel.text = [metaData objectForKey:@"user"];
    userLabel.backgroundColor = [UIColor clearColor];
    userLabel.textColor = [UIColor whiteColor];
    [userLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:10]];

    UILabel *updateDate = (UILabel*) [cell.contentView viewWithTag:114];
    NSString *myString = @"Posted at: ";
    NSString *test = [myString stringByAppendingString:[metaData objectForKey:@"time"]];
    updateDate.text = test;
    updateDate.backgroundColor = [UIColor clearColor];
    updateDate.textColor = [UIColor whiteColor];
    [updateDate setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:12]];

    /*
    UILabel *commentLabel = (UILabel*) [cell.contentView viewWithTag:95];
    NSNumber *message_id = [NSNumber numberWithInt:[[metaData objectForKey:@"comments_count"] intValue]];

    commentLabel.text = [message_id stringValue];
    commentLabel.textColor = [UIColor colorWithRed:51/255.0 green:152/255.0 blue:219/255.0 alpha:1.0];
    [commentLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    commentLabel.layer.cornerRadius = commentLabel.frame.size.width/2;
    commentLabel.layer.borderWidth = 1.0f;
    commentLabel.layer.borderColor = [UIColor colorWithRed:51/255.0 green:152/255.0 blue:219/255.0 alpha:1.0].CGColor;
    commentLabel.layer.masksToBounds = YES;
    */
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

            UIImageView *weakImageView = (UIImageView*)[weakCell.contentView viewWithTag:110];
            weakImageView.layer.borderColor = [UIColor whiteColor].CGColor;
            weakImageView.layer.borderWidth =1.0f;
            weakImageView.layer.cornerRadius = 50;
            weakImageView.clipsToBounds = YES;
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

    /*
        //setup background image-------------------------------
    UIImage *backgroundImage = [UIImage imageNamed:@"menu_bg"];
    UIImageView *backgroundImageView=[[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    [cell insertSubview:backgroundImageView atIndex:0];
        //end of setting up background image-------------------
    */
    
    return cell;
}


- (void)viewWillAppear:(BOOL)animated{

  [self.tableView reloadData];
}

-(void)backButtonPressed{

    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)AddCommentRefresh:(NSNotification *) notification
{
    [self loadStoreComments];
}
@end
