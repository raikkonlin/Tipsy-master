//
//  APPChildViewController.m
//  testt
//
//  Created by pp1285 on 2015/10/23.
//  Copyright © 2015年 EthanChou. All rights reserved.
//

#import "APPChildViewController.h"
#import "UIImageView+AFNetworking.h"
#import "EventDetailTableViewController.h"
#import <Parse/Parse.h>

@interface APPChildViewController (){
    NSMutableDictionary *dic ;
    NSMutableArray *array;
}

@end

@implementation APPChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s", __FUNCTION__);
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addMovieNoti:) name:@"AddMovieNoti" object:nil];
    AppViewController *controller = [[self parentViewController] parentViewController];
    

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_bg"]];


    self.screenNumber.text = [NSString stringWithFormat:@"%@", controller.APITitlearray[self.index]];
    self.BackGroundImage.image = controller.APIImagearray[self.index];

    
//    使用parse抓EventDetail
    
//    總共需要：picture/,subjects/,store/,price/,partypic1,partypic2,partypic3,partypic4,latitude/,longtitude/,index/
    //  Parse抓movie資料
    PFQuery *query = [PFQuery queryWithClassName:@"Events"];
    [query orderByDescending:@"index"];
//     [query whereKey:@"index" equalTo:@3];
    [query whereKey:@"index" containedIn:@[@"1"]];
    NSLog(@"%@", query);
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {

        for (PFObject *event in objects) {
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
            dic = [@{@"subjects":subjects,
                     @"store":store,
                     @"price":price,
                     @"latitude":latitude,
                     @"longtitude":longtitude,
                     @"index":index,
                     @"date":date}
                   mutableCopy];
            //  抓出照片～file轉data~~~
            PFFile *picture = event[@"picture"];
            [picture getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                if (error == nil) {
                    //  data轉image~~
                    UIImage *image = [[UIImage alloc]initWithData:data];
                    [dic setObject:image forKey:@"picture"];
                    NSLog(@"picture = %@", dic);
//                    [[NSNotificationCenter defaultCenter]
//                     postNotificationName:@"sendDetail" object:nil
//                     userInfo:dic];
                }
                
            }];
            PFFile *partypic1 = event[@"partypic1"];
            [partypic1 getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                if (error == nil) {
                    //  data轉image~~
                    UIImage *image = [[UIImage alloc]initWithData:data];
                    [dic setObject:image forKey:@"partypic1"];
                    NSLog(@"picture = %@", dic);
//                    [[NSNotificationCenter defaultCenter]
//                     postNotificationName:@"sendDetail" object:nil
//                     userInfo:dic];
                    
                }
                
            }];
            

//        NSLog(@"%@",dic);
        };
//        NSLog(@"%@",dic);
    [self.view reloadInputViews];}];
    
    
//    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
//    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
//    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];

//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = NO;

}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"%s", __FUNCTION__);

}
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"%s", __FUNCTION__);

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    
    return self;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)addMovieNoti:(NSNotification *)noti{
    //notiiiii
    NSDictionary *imageDic = noti.userInfo;
    AppViewController *controller = [[self parentViewController] parentViewController];
    [controller.APIImagearray addObject: imageDic[@"image"]];
    self.BackGroundImage.image = controller.APIImagearray[self.index];

}
- (IBAction)dismissBut:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EventDetailTableViewController *controller =  [storyboard instantiateViewControllerWithIdentifier:@"EventDetailTableViewController"];
    [self presentViewController:controller animated:YES completion:nil];
    
}
@end
