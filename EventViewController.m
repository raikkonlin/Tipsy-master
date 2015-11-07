//
//  EventViewController.m
//  ProjTipsy
//
//  Created by pp1285 on 2015/11/2.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import "EventViewController.h"
#import "ITRAirSideMenu.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "EventDetailTableViewController.h"
#import <Parse/Parse.h>
#import "AFNetworking.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface EventViewController () {
    NSMutableDictionary *dic ;
    NSMutableDictionary *DetailDic;
    NSMutableArray *arrayall;
    NSUInteger totalcount;
    NSMutableArray *arrayDetail;
}
@property (weak, nonatomic) IBOutlet UIScrollView *eventPageView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


@end

@implementation EventViewController
+ (instancetype) controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([EventViewController class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    DetailDic = [[NSMutableDictionary alloc]init];
    arrayall = [[NSMutableArray alloc]init];
    arrayDetail =[[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendDetail:) name:@"sendDetail" object:nil];

    [self getParseData];

    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
    _pageControl.backgroundColor = [UIColor blackColor];
    
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:YES withAnimation:YES];
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    [navBar setBarTintColor:[UIColor blackColor]];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self action:@selector(presentLeftMenuViewController)];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
    
//    [self setEventPage];
    
    UILongPressGestureRecognizer *LongPress = [[UILongPressGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(LongPress:)];
    LongPress.minimumPressDuration =0.3;
    [self.view addGestureRecognizer:LongPress];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setEventPage{
    //UIPageControl設定

    [_pageControl setNumberOfPages:(NSInteger)totalcount];
    [_pageControl setCurrentPage:0];
    
    NSLog(@"_pageControl numOfPages:%ld", _pageControl.numberOfPages);
    
    //UIScrollView設定
    [_eventPageView setPagingEnabled:YES];
    [_eventPageView setShowsHorizontalScrollIndicator:NO];
    [_eventPageView setShowsVerticalScrollIndicator:NO];
    [_eventPageView setScrollsToTop:NO];
    [_eventPageView setDelegate:self];
    
       }

//
//-(void)getAPIdata {
//
//    _APIImagearray = [[NSMutableArray alloc]init];
//    _APITitlearray = [[NSMutableArray alloc]init];
//
//    NSURL *url = [NSURL URLWithString:@"http://www.pa9.club//api/v1/events"];
//    NSData *data = [[NSData alloc]
//                    initWithContentsOfURL:url];
//
//    NSError *jsonError;
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
//    NSArray *array = dic[@"data"];
//    
//    for (NSDictionary *diccc in array) {
//        NSLog(@"my titile%@", diccc[@"title"]);
//        
//        [self.APITitlearray addObject:diccc[@"title"]];
//        
//        NSURL *url = [NSURL URLWithString:diccc[@"image"]];
//        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
//                                                    cachePolicy:NSURLRequestReturnCacheDataElseLoad
//                                                timeoutInterval:30];
//        
//        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            if(data) {
//            UIImage *image = [[UIImage alloc] initWithData:data];
//            dispatch_async(dispatch_get_main_queue(), ^{
////                [self.APIImagearray addObject:image];
//            NSDictionary *imageDic = @{@"image":image};
//            [[NSNotificationCenter defaultCenter]
//             postNotificationName:@"AddMovieNoti" object:nil
//                userInfo:imageDic];
//            });
////                [self.view reloadInputViews];
//            }
//            }];
//        [self.view reloadInputViews];
//        [task resume];
//    }
//}

-(void)getParseData {
    //    轉球時間
                                UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]
                                                                                  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                                [self.view addSubview:activityIndicatorView];
                                activityIndicatorView.center = self.view.center;
                                [self.view bringSubviewToFront:activityIndicatorView];
                                [activityIndicatorView startAnimating];
    //    總共需要：picture/,subjects/,store/,price/,partypic1,partypic2,partypic3,partypic4,latitude/,longtitude/,index/
    //  Parse抓movie資料
    PFQuery *query = [PFQuery queryWithClassName:@"Events"];
    [query orderByDescending:@"index"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {

        totalcount = objects.count;
        NSLog(@"count %lu", totalcount);

        for (PFObject *event in objects) {
            
            
//            NSLog(@"event %@", event);
            //  抓出名稱
            PFObject *subjects = event[@"subjects"];
            //  抓出店名
            PFObject *store = event[@"store"];
            //  抓出價錢
            PFObject *price = event[@"price"];
            //  抓出緯度
            PFObject *latitude = event[@"latitude"];
            //  抓出經度
            PFObject *longtitude = event[@"longtitude"];
            //  抓出index
            PFObject *index = event[@"index"];
            //  抓出日期
            
            
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyy-MM-dd"];
            NSString *date = [df stringFromDate:event[@"date"]];
            
            
            
            //  整理放進dic
           
            //  抓出照片～file轉data~~~
          
            PFFile *picture = event[@"picture"];
            [picture getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                if (error == nil) {
                    //  data轉image~~
                    UIImage *image = [[UIImage alloc]initWithData:data];
                    
                    dic = [@{@"subjects":subjects,
                             @"store":store,
                             @"price":price,
                             @"latitude":latitude,
                             @"longtitude":longtitude,
                             @"index":index,
                             @"date":date}
                           mutableCopy];
                    [arrayall addObject:image];

                    [dic setObject:image forKey:@"picture"];
//                    [dic setObject:[NSNumber numberWithInt:i] forKey:@"index"];
                  
                   
                    //製作ScrollView的內容
                    CGFloat width, height;
                    width = [UIScreen mainScreen].bounds.size.width;
                    height = [UIScreen mainScreen].bounds.size.height;
                    [_eventPageView setContentSize:CGSizeMake(width * (NSInteger)totalcount, _eventPageView.frame.size.height)];
                    
                    for (int i=_pageControl.numberOfPages; i !=0; i--) {
                        CGRect frame = CGRectMake(width*(i-1), 0, width, height);
                        UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
                        
                        //                        NSLog(@"index dic %@",indexDic);
                        //使用QuartzCore.framework替UIView加上圓角
//                        NSLog(@"%@,%@", dic[@"index"], dic[@"picture"]);
                        [imageView.layer setCornerRadius:15.0];
                        
                        if (i == [dic[@"index"] intValue]) {
                            
                            imageView.image = dic[@"picture"];

                            [_eventPageView addSubview:imageView];
                            [arrayDetail addObject:dic];
//                            製作btn
//                            NSString *btn = [NSString stringWithFormat:@"ShowView%d", i];
                            UIButton *detailbtn = [UIButton buttonWithType:UIButtonTypeCustom];
                            [detailbtn addTarget:self
                                          action:@selector(partyDetailPressed:)
                                forControlEvents:UIControlEventTouchUpInside];
                            UIImage *image = [UIImage imageNamed:@"button"];
                            [detailbtn setImage:image forState:UIControlStateNormal];
                            detailbtn.layer.cornerRadius = 100;
                            detailbtn.frame = CGRectMake(width*(i-1)+20.0, 300.0, 200.0, 200.0);
                            [_eventPageView addSubview:detailbtn];
                        }
                    }
                    
                }
                
                }];


        };
        [self setEventPage];

    }];

    
}

-(void)sendDetail:(NSNotification *)noti{
    //notiiiii
    NSDictionary *dicget = noti.userInfo;
//    [arrayall addObject:dicget];
//    NSLog(@"arrayall %@", arrayall);
//    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    NSInteger currentPage = ((_eventPageView.contentOffset.x - width / 2) / width) + 1;
    [_pageControl setCurrentPage:currentPage];
}


- (IBAction)changeCurrentPage:(UIPageControl *)sender {
    NSInteger page = _pageControl.currentPage;
    
    CGFloat width, height;
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    CGRect frame = CGRectMake(width*page, 0, width, height);
    
    [_eventPageView scrollRectToVisible:frame animated:YES];
}


- (void) presentLeftMenuViewController{
    
    //show left menu with animation
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
    
}


-(void) LongPress:(id)sender {
    //    NSLog(@"array  = %@", arrayDetail);
    //    NSLog(@"currentPage = %ld", _pageControl.currentPage);
    for (NSMutableDictionary *currentPagedic in arrayDetail) {
        //        NSLog(@"%d, %ld",[dict[@"index"] intValue], _pageControl.currentPage);
        if ([currentPagedic[@"index"] intValue] == _pageControl.currentPage + 1 ) {
            NSLog(@"asdfasdfasdf");
            //            [[NSNotificationCenter defaultCenter]
            //             postNotificationName:@"sendDetail" object:nil
            //             userInfo:dict];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            EventDetailTableViewController *controller =  [storyboard instantiateViewControllerWithIdentifier:@"EventDetailTableViewController"];
            controller.Detaildic = currentPagedic;
            [self presentViewController:controller animated:YES completion:nil];
            
            
        }
    }

}



@end
