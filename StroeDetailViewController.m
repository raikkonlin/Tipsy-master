    //
    //  ShowDescriptionVC.m
    //  ProjTipsy
    //
    //  Created by LINCHUNGYAO on 2015/10/30.
    //  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
    //

#import "StroeDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import "CommentsTableVC.h"
#import <SystemConfiguration/SystemConfiguration.h> //檢查連線狀況
#import "AFNetworking.h"

@interface StroeDetailViewController ()<UISearchBarDelegate,UISearchDisplayDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{

    NSArray *commentArray;
    NSMutableArray *eventArray;
    NSArray *dateArray;
    NSString *objectID;
    NSMutableArray *upComingEventArray;
}

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *animationImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelLike;
@property (weak, nonatomic) IBOutlet UIButton *buttonLike;
@property (weak, nonatomic) IBOutlet UIPickerView *eventPickerView;
@property (weak, nonatomic) IBOutlet UIButton *buttonComment;
@property (weak, nonatomic) IBOutlet UILabel *labelComment;
@property (weak, nonatomic) IBOutlet UILabel *mostRecentlyEvent;

@end


@implementation StroeDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    eventArray=@[@"Friday's Night : 2015-11-11",
                 @"Double Eleven's Day : 2015-11-13",
                 @"DJ 黃杰之夜 : 2015-11-14"];
        //    dateArray=@[@"2015-11-11",
        //                @"2015-11-13",
        //                @"2015-11-14"];

   */
    eventArray = nil;
    eventArray = [[NSMutableArray alloc] initWithCapacity:5];

        //************************************************
    UIImage *backgroundImage = [UIImage imageNamed:@"menu_bg"];
    UIImageView *backgroundImageView=[[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
        //***********************************************

        //設定UIScrollView
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    CGFloat width , height;
    width = self.scrollView.frame.size.width;
    height = self.scrollView.frame.size.height;

    CGFloat availableScrollViewHeight = screenHeight /2 - 100;
    self.scrollView.contentSize = CGSizeMake(screenWidth * self.pageControl.numberOfPages, availableScrollViewHeight);


        //設定UIImageView的圖片顯示模式
    UIImageView *img1 = [[UIImageView alloc ]initWithFrame:CGRectMake(0, 44, screenWidth, availableScrollViewHeight)];
    UIImageView *img2 = [[UIImageView alloc ]initWithFrame:CGRectMake(0, 44, screenWidth, availableScrollViewHeight)];
    UIImageView *img3 = [[UIImageView alloc ]initWithFrame:CGRectMake(0, 44, screenWidth, availableScrollViewHeight)];



    PFQuery *query = [PFQuery queryWithClassName:@"Store"];
    [query whereKey:@"storename" equalTo:self.storeName];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects,NSError *_Nullable error) {
        for(PFObject *storeImage in objects) {

            PFFile *photo1 = storeImage[@"Picture1"];
            PFFile *photo2 = storeImage[@"Picture2"];
            PFFile *photo3 = storeImage[@"Picture3"];
            self.labelLike.text = storeImage[@"Like"] ;
            objectID = storeImage[@"objectId"];



            if ( storeImage[@"event1"] != NULL) {

                 [eventArray addObject:storeImage[@"event1"]];
                self.mostRecentlyEvent.text = [NSString stringWithFormat:@"  %@", eventArray[0]];
                 NSLog(@"eventarray %lu ",eventArray.count);
                NSLog(@"storeImage[@event1] %@ ",storeImage[@"event1"]);
                  }
            if( storeImage[@"event2"] != NULL){

                     [eventArray addObject:storeImage[@"event2"]];
                      NSLog(@"eventarray %lu ",eventArray.count);
                      NSLog(@"storeImage[@event2] %@ ",storeImage[@"event2"]);
                      }
            if(storeImage[@"evnet3"] != NULL){

                         [eventArray addObject:storeImage[@"evnet3"]];
                          NSLog(@"eventarray %lu ",eventArray.count);
                          NSLog(@"storeImage[@event3] %@ ",storeImage[@"evnet3"]);
                          }
            if(storeImage[@"event4"] != NULL){

                             [eventArray addObject:storeImage[@"event4"]];
                              NSLog(@"eventarray %lu ",eventArray.count);
                              NSLog(@"storeImage[@event4] %@ ",storeImage[@"event4"]);
                              }
            NSLog(@"storeImage[@event5] %@ ",storeImage[@"event5"]);
            if(storeImage[@"event5"] != NULL){

                                 [eventArray addObject:storeImage[@"event5"]];
                                  NSLog(@"eventarray %lu ",eventArray.count);
                                  NSLog(@"storeImage[@event5] %@ ",storeImage[@"event5"]);
                                  }


                                  NSLog(@"eventarray.count %lu ",eventArray.count);
            upComingEventArray = [eventArray mutableCopy];
            [upComingEventArray removeObjectAtIndex: 0];
            [self.eventPickerView reloadAllComponents];

            [photo1 getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError *_Nullable error) {

                if(error == nil) {
                    UIImage *image = [[UIImage alloc] initWithData:data];
                    img1.image = image;
//                    [self.view addSubview:imageView];
                  }
            }];

        [photo2 getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError *_Nullable error) {

            if(error == nil) {
                UIImage *image = [[UIImage alloc] initWithData:data];
                img2.image = image;
                    //                    [self.view addSubview:imageView];
            }
        }];

     [photo3 getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError *_Nullable error) {

        if(error == nil) {
            UIImage *image = [[UIImage alloc] initWithData:data];
            img3.image = image;
                //                    [self.view addSubview:imageView];
        }
    }];

  }

    }];



    img1.contentMode = UIViewContentModeScaleToFill;
    img2.contentMode = UIViewContentModeScaleToFill;
    img3.contentMode = UIViewContentModeScaleToFill;

    img1.center=self.scrollView.center;
    img2.center=self.scrollView.center;
    img3.center=self.scrollView.center;


    CGRect screenRectFit = CGRectMake(0, 20,  screenWidth, availableScrollViewHeight );

    img1.frame = screenRectFit;
    img2.frame = CGRectOffset( img1.frame, screenWidth, 0);
    img3.frame = CGRectOffset( img2.frame, screenWidth, 0);

    [self.scrollView addSubview:img1];
    [self.scrollView addSubview:img2];
    [self.scrollView addSubview:img3];


        //UIPageControl設定
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(changeCurrentPage:) forControlEvents : UIControlEventValueChanged];
    [self.view addSubview:self.pageControl];

    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = NO;


        //動畫------------------------------------------
    [self animateImages];

        //setup labelLike

    self.labelLike.layer.cornerRadius = 15;
    self.labelLike.layer.borderWidth = 1.0f;
    self.labelLike.textColor = [UIColor colorWithRed:51/255.0 green:152/255.0 blue:219/255.0 alpha:1.0];
    self.labelLike.layer.borderColor = [UIColor colorWithRed:51/255.0 green:152/255.0 blue:219/255.0 alpha:1.0].CGColor;
    self.labelLike.layer.masksToBounds = YES;

    self.animationImageView.layer.cornerRadius = self.animationImageView.frame.size.width/2;
    self.animationImageView.layer.borderWidth = 2.0f;
    self.animationImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.animationImageView.layer.masksToBounds = NO;
    self.animationImageView.clipsToBounds = YES;
        //end of 動畫-----------------------------------

        //set buttoncomment attributes----------------
    self.buttonComment.layer.borderColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0].CGColor;
    self.buttonComment.layer.borderWidth = 1.0f;
    self.buttonComment.layer.cornerRadius = 5.0f;
    self.buttonComment.clipsToBounds = YES;
        //end of setting buttoncomment attributes-----

        //set labelCommnet attributes------------------------
    self.labelComment.text = self.commentLabel;
    self.labelComment.layer.borderColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0].CGColor;
    self.labelComment.layer.borderWidth = 1.0f;
    self.labelComment.layer.cornerRadius = 7.0f;//self.labelComment.frame.size.width /2 ;
    self.labelComment.clipsToBounds = YES;
        //end of setting labelCommnet attributes-------------



    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AddCommentRefresh:)
                                                 name:@"AddCommentRefresh"
                                               object:nil];
    


}

- (void)AddCommentRefresh:(NSNotification *) notification
{
   [self loadStoreComments];
   }


-(void)loadStoreComments
{
        //檢查連線狀況
    NSString *host = @"www.apple.com";
    SCNetworkReachabilityRef  reachability = SCNetworkReachabilityCreateWithName(nil, host.UTF8String);
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
    commentArray= [NSMutableArray arrayWithCapacity:40];

        // 將網址字串轉為 NSURLRequest 物件 request
    NSString *urlString = @"http://www.pa9.club/api/v1/stores/";
//    urlString = [urlString stringByAppendingString:self.storeId];
//    NSLog(@"self.storeId %@",self.storeId);
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

        commentArray = data[@"data"];
        NSLog(@"dataddddddd  %@",commentArray);
        NSLog(@" commentArray  %@ ",commentArray);
        for (NSDictionary *dict in commentArray) {
            if ( [dict[@"name"] isEqualToString:self.storeName]) {
                self.labelComment.text = dict[@"comments_count"];
            }

        }

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




    //PickerView setting-------------------
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSLog(@"upComingEventArray.count %lu",upComingEventArray.count);
    return upComingEventArray.count;
}

    // normal setup of PickerView
    //-(nullable NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //
    //    return eventArray[row];
    //}
    //custom setup of PickerView
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    UILabel *retval = (UILabel*)view;

    if (!retval) {
        retval = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
    }

    retval.text = upComingEventArray[row];
    NSLog(@"retval.text %@",retval.text);
    retval.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    retval.textAlignment = NSTextAlignmentCenter;
    retval.textColor = [UIColor whiteColor];

    return retval;

}
    //end of PickerView setting-------------
- (IBAction)buttonCommentPressed:(UIButton *)sender {

        //    unsigned long commentsCount = 0;

        //    commentsCount = [self.labelComment.text integerValue];

    CommentsTableVC *controllerComment = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentsTableVC"];

    controllerComment.storeId = self.storeId;

    [self presentViewController:controllerComment animated:YES completion:nil];


}


- (IBAction)buttonLikePressed:(id)sender {

    unsigned long countLike;

    NSString *str = self.labelLike.text;

    countLike = [str integerValue];
    NSLog(@"------------------------------------");
    NSLog(@"countLike=%lu",countLike);
    countLike ++;

    self.labelLike.text = [NSString stringWithFormat:@"%lu",countLike];
    [self.buttonLike setShowsTouchWhenHighlighted:YES];

        //save to parse.com

    PFQuery *query = [PFQuery queryWithClassName:@"Store"];
    [query whereKey:@"storename" containsString:self.storeName];

    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects,NSError * _Nullable error) {
        for(PFObject *store in objects)
        {
            store[@"Like"] = self.labelLike.text;
            [store saveInBackground];
         }
    }];

//    [storeLike saveInBackgroundWithBlock:^(BOOL succeeded, NSError
//                                        *error) {
//        if (succeeded) {
//                // The object has been saved.
//            NSLog(@"succeed");
//        } else {
//              NSLog(@"Error: %@ %@", error, [error userInfo]);
//        } }];





}

-(void)animateImages{
    static int countForAnimation = 0;
    NSArray *animationImages = @[[UIImage imageNamed:@"dance1.png"],[UIImage imageNamed:@"dance2.png"],[UIImage imageNamed:@"dance3.png"]];
    UIImage *image = [animationImages objectAtIndex:(countForAnimation % [animationImages count])];

    [UIView transitionWithView:self.animationImageView
                      duration:2.0f
                       options:(UIViewAnimationOptionTransitionCrossDissolve)
                    animations:^{
                        self.animationImageView.image = image;
                    }
                    completion:^(BOOL finished) {
                        [self animateImages];
                        countForAnimation++;
                    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat width = self.scrollView.frame.size.width;
    NSInteger currentPage = ((self.scrollView.contentOffset.x - width / 2) / width) + 1;
    [self.pageControl setCurrentPage:currentPage];

}

    //setNavigationBarHidden
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}


- (IBAction)changeCurrentPage:(UIPageControl *)sender {
    NSInteger page = self.pageControl.currentPage;
    CGFloat width;
    width = self.scrollView.frame.size.width;
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
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


}

-(void)backButtonPressed{
    [self dismissViewControllerAnimated:NO completion:nil];
}

    //- (BOOL)prefersStatusBarHidden {
    //    return [self shouldHideStatusBar];
    //}


@end
