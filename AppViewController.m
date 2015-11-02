//
//  AppViewController.m
//  testt
//
//  Created by pp1285 on 2015/10/23.
//  Copyright © 2015年 EthanChou. All rights reserved.
//

#import "AppViewController.h"
#import "APPChildViewController.h"
#import "ITRAirSideMenu.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"

@interface AppViewController ()

@end

@implementation AppViewController
+ (instancetype) controller{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AppViewController class])];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    APPChildViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    self.view.backgroundColor = [UIColor clearColor];

    [self.pageController didMoveToParentViewController:self];
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
    pageControl.backgroundColor = [UIColor clearColor];



    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:YES withAnimation:YES];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UINavigationBar *naviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, width, 50)];

    [self.view addSubview:naviBar];

 
    [naviBar setBarTintColor:[UIColor clearColor]];
    [naviBar setBackgroundImage:[UIImage new]
                  forBarMetrics:UIBarMetricsDefault];
    naviBar.shadowImage = [UIImage new];
    naviBar.translucent = YES;
    naviBar.backgroundColor = [UIColor clearColor];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Delete-50"]
        style:UIBarButtonItemStylePlain
        target:self action:@selector(presentLeftMenuViewController)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
    
//    取api的東西
//    [self performSelector:@selector(getAPIdata) withObject:nil];
    [self getAPIdata];
//    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
//    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];

//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
//   self.navigationController.navigationBar.translucent = YES;
//    self.translucent = YES;


    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
            //hack because the map turns the bar to a dark grey and then it stays dark grey
        NSLog(@"%%%%%%");
        self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
        self.navigationController.navigationBar.translucent = NO;
        self.translucent = NO;
            //
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
            //hack because the map turns the bar to a dark grey and then it stays dark grey
        self.navigationController.navigationBar.translucent = YES;
            //I don't set the toolbar transparency back to YES because I
            //never wanted it translucent, just had to explicitly set it
            //to avoid it turning grey.
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(APPChildViewController *)viewController index];

    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(APPChildViewController *)viewController index];
    
//    NSUInteger index = childViewController.index;
    NSLog(@"apiarray.count %lu", _APIImagearray.count );
    NSLog(@"%lu", index);
    if (index == self.APIImagearray.count-1 ) {
        
        return nil;
    }
    
     index++;
    return [self viewControllerAtIndex:index];
    
}
- (APPChildViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    APPChildViewController *childViewController = [[APPChildViewController alloc] initWithNibName:@"APPChildViewController" bundle:nil];
    childViewController.index = index;
    
    return childViewController;
}
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 4;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}
- (void) presentLeftMenuViewController{
    
    //show left menu with animation
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
    
}

-(void)getAPIdata {
    
    _APIImagearray = [[NSMutableArray alloc]init];
    _APITitlearray = [[NSMutableArray alloc]init];
    
    NSURL *url = [NSURL URLWithString:@"http://www.pa9.club//api/v1/events"];
    NSData *data = [[NSData alloc]
                    initWithContentsOfURL:url];
    
    NSError *jsonError;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
    NSArray *array = dic[@"data"];
    
    for (NSDictionary *diccc in array) {
        NSLog(@"my titile%@", diccc[@"title"]);
        
        [self.APITitlearray addObject:diccc[@"title"]];
        
        NSURL *url = [NSURL URLWithString:diccc[@"image"]];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                    cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                timeoutInterval:30];
        
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest
        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data) {
            UIImage *image = [[UIImage alloc] initWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.APIImagearray addObject:image];
                NSDictionary *imageDic = @{@"image":image};
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"AddMovieNoti" object:nil
                 userInfo:imageDic];
            });
//                [self.view reloadInputViews];
        }
        }];
        [self.view reloadInputViews];
        [task resume];
    }
}
@end
