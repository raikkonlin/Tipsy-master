//
//  CommentsTableViewController.m
//  ProjTipsy
//
//  Created by LINCHUNGYAO on 2015/11/1.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import "CommentsTableViewController.h"
#import "AddYourOpinionVC.h"

@interface CommentsTableViewController () <UIScrollViewDelegate> {

    __weak UIButton *_buttonToComment;
}
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
//@property(strong,nonatomic) NSString  *messageObjectID;

@end


@implementation CommentsTableViewController

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
            // Custom the table

            // The className to query on
        self.parseClassName = @"Message";

            // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"message"; //self.objectID;


            // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;

            // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;

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
        NSLog(@"[self.objects count]=%lu",[self.objects count]);
    }

//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            [query orderByDescending:@"msgTime"];
//            [query includeKey:@"storename"];
/*
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable
                                              objects, NSError * _Nullable error) {
        for(PFObject *msg in objects) {
            msg[@"storename"] = self.objectID;
            [msg saveInBackground];
} }];
*/
    NSLog(@"[self.objects count2]=%lu",[self.objects count]);
    return query;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"msgReuseId";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

        // Configure the cell
    PFFile *thumbnail = [object objectForKey:@"userPics"];
    PFImageView *thumbnailImageView = (PFImageView*)[cell.contentView viewWithTag:80];
    thumbnailImageView.image = [UIImage imageNamed:@"placeholder.png"];
    thumbnailImageView.file = thumbnail;
    thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.size.width / 2;
    thumbnailImageView.layer.masksToBounds = YES;
    thumbnailImageView.contentMode = UIViewContentModeScaleToFill;
    thumbnailImageView.layer.borderWidth = 1.0f;
    thumbnailImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [thumbnailImageView loadInBackground];

    UILabel *msgLabel = (UILabel*) [cell.contentView viewWithTag:81];
    msgLabel.text = [object objectForKey:@"message"];
    NSLog(@"message=%@",[object objectForKey:@"message"]);
    msgLabel.textColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
    [msgLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:12]];

    UILabel *dateLabel = (UILabel*) [cell.contentView viewWithTag:82];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *date = [dateFormatter stringFromDate:[object objectForKey:@"msgTime"]];
    dateLabel.text = date;
    dateLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];

        //setup background image-------------------------------
            UIImage *backgroundImage = [UIImage imageNamed:@"menu_bg"];
            UIImageView *backgroundImageView=[[UIImageView alloc] initWithFrame:self.view.frame];
            backgroundImageView.image=backgroundImage;
            [cell insertSubview:backgroundImageView atIndex:0];
        //end of setting up background image-------------------


    return cell;
}





-(void)viewDidLoad{
    [super viewDidLoad];

    self.userImage.image = [UIImage imageNamed:@"Jonny.jpg"];
    self.userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userImage.layer.borderWidth =3.0f;
    self.userImage.layer.cornerRadius = self.userImage.frame.size.width/2;
    self.userImage.clipsToBounds = YES;

    self.labelUserName.text = @"Johnny Scrap";
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

}

-(void)AddYourOpinionButton{

    AddYourOpinionVC *controllerEvent = [self.storyboard instantiateViewControllerWithIdentifier:@"AddYourOpinionVC"];
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
}

-(void)backButtonPressed{

    [self dismissViewControllerAnimated:NO completion:nil];
}


@end
