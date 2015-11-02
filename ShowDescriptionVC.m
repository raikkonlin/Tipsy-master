    //
    //  ShowDescriptionVC.m
    //  ProjTipsy
    //
    //  Created by LINCHUNGYAO on 2015/10/30.
    //  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
    //

#import "ShowDescriptionVC.h"
#import <Parse/Parse.h>
#import "ParseUI/ParseUI.h"
#import "CommentsTableViewController.h"


@interface ShowDescriptionVC ()<UISearchBarDelegate,UISearchDisplayDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{

    NSArray *eventArray;
    NSArray *dateArray;
}
@property (nonatomic, strong) UISearchBar *locationSearchBar;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *animationImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelLike;
@property (weak, nonatomic) IBOutlet UIButton *buttonLike;
@property (weak, nonatomic) IBOutlet UIPickerView *eventPickerView;
@property (weak, nonatomic) IBOutlet UIButton *buttonComment;
@property (weak, nonatomic) IBOutlet UILabel *labelComment;

@end


@implementation ShowDescriptionVC
/*
- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
            // Custom the table

            // The className to query on
        self.parseClassName = @"Store";

            // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"Message";

            // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;

            // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;

            // The number of objects to show per page
            //self.objectsPerPage = 10;
    }
    return self;
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];

        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }

    [query whereKey:@"storename" equalTo:@"self.storeName"];

        //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        //    NSDate *comparingDate = [dateFormatter dateFromString:@"2015-10-04"];
        //    [query whereKey:@"date" greaterThan:comparingDate];
        //    [query orderByDescending:@"date"];


    return query;
}
*/

/*

    - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
        if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
            UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Show" style:UIBarButtonItemStylePlain
                                                                             target:self action:@selector(refreshPropertyList:)];
            self.navigationItem.rightBarButtonItem = anotherButton;
        }
        return self;
    }
*/
- (void)viewDidLoad
{
    [super viewDidLoad];

    eventArray=@[@"Friday's Night : 2015-11-11",
                 @"Double Eleven's Day : 2015-11-13",
                 @"DJ 黃杰之夜 : 2015-11-14"];
//    dateArray=@[@"2015-11-11",
//                @"2015-11-13",
//                @"2015-11-14"];


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

    CGFloat availableScrollViewHeight = screenHeight /2-50;
    self.scrollView.contentSize = CGSizeMake(screenWidth * self.pageControl.numberOfPages, availableScrollViewHeight);

        //設定UIImageView的圖片顯示模式
    PFImageView *img1 = [[PFImageView alloc ]initWithFrame:CGRectMake(0, 44, screenWidth, availableScrollViewHeight)];
    PFImageView *img2 = [[PFImageView alloc ]initWithFrame:CGRectMake(0, 44, screenWidth, availableScrollViewHeight)];
    PFImageView *img3 = [[PFImageView alloc ]initWithFrame:CGRectMake(0, 44, screenWidth, availableScrollViewHeight)];

    img1.file = self.imageFile1;
    img2.file = self.imageFile2;
    img3.file = self.imageFile3;

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

    [img1 loadInBackground];
    [img2 loadInBackground];
    [img3 loadInBackground];

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
    self.labelLike.text = self.likeLabel;
    self.labelLike.layer.cornerRadius = self.labelLike.frame.size.width/2;
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
    self.labelComment.layer.borderColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0].CGColor;
    self.labelComment.layer.borderWidth = 1.0f;
    self.labelComment.layer.cornerRadius = 7.0f;//self.labelComment.frame.size.width /2 ;
    self.labelComment.clipsToBounds = YES;
        //end of setting labelCommnet attributes-------------
    

}

    //PickerView setting-------------------
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return eventArray.count;
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

    retval.text = eventArray[row];
    retval.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    retval.textAlignment = NSTextAlignmentCenter;
    retval.textColor = [UIColor whiteColor];

    return retval;

}
    //end of PickerView setting-------------

- (IBAction)buttonCommentPressed:(UIButton *)sender {

//    unsigned long commentsCount = 0;

//    commentsCount = [self.labelComment.text integerValue];

    CommentsTableViewController *controllerComment = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentsTableViewController"];

    controllerComment.objectID = self.objectID;

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
    [query getObjectInBackgroundWithId:self.objectID block:^(PFObject *storeLike, NSError *error) {

        storeLike[@"storename"] = self.storeName;
        storeLike[@"Like"] = self.labelLike.text;
        [storeLike saveInBackground];
    }];

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
