//
//  DJViewController.m
//  ProjTipsy
//
//  Created by pp1285 on 2015/11/4.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import "DJViewController.h"
#import <Parse/Parse.h>
#import "AFNetworking.h"
#import "ITRAirSideMenu.h"
#import "AppDelegate.h"


@implementation DJViewController
+ (instancetype) controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([DJViewController class])];
}

-(void)viewDidLoad{
    
//    背景變黑色
    [self.view setBackgroundColor:[UIColor blackColor]];
//    設定soundcloudView
//    UIImage *image = [UIImage imageNamed:@"placeholder.png"];
//    _soundCloudView.backgroundColor = [UIColor colorWithPatternImage:image];
    _soundCloudView.scrollView.scrollEnabled =NO;
    NSURL *url = [NSURL URLWithString:@"https://soundcloud.com/dj-soda-3/soda-fmm"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_soundCloudView loadRequest:request];
//    設定youtubeView
    [self.youtubeView loadWithVideoId:@"88S5TGJp13g"];
//    設定btn啦
    [self setScrollViewBtn];
//    設定上面那個bar
    [self setNaviBar];
    
}

-(void) setNaviBar {
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self action:@selector(presentLeftMenuViewController)];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0];
    
    
}

-(void)setScrollViewBtn{
    _DJdic = [[NSMutableDictionary alloc]init];
    _btnArray = [[NSMutableArray alloc]init];
    _DJArray = [[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"DJ"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        for (PFObject *DJ in objects) {
            
            //            NSLog(@"event %@", event);
            //  抓出名稱
            PFObject *name = DJ[@"name"];
            PFObject *totalname = DJ[@"totalname"];
            PFObject *location = DJ[@"location"];
            PFObject *youtube = DJ[@"youtube"];
            PFObject *soundcloud = DJ[@"soundcloud"];
            PFFile *photo = DJ[@"photo"];

            _DJdic = [@{@"name":name,@"totalname":totalname,@"location":location,@"youtube":youtube,@"soundcloud":soundcloud,@"photo":photo}mutableCopy];
            
            [_DJArray addObject:DJ];

            [_btnArray addObject:name];
            //製作ScrollView的內容
            CGFloat width, height;
            width = [UIScreen mainScreen].bounds.size.width;
            height = _btnScorllview.frame.size.height;
            NSLog(@"array%@", _btnArray);
            [_btnScorllview setContentSize:CGSizeMake(width/4 * _btnArray.count , _btnScorllview.frame.size.height)];
            
            
//                            製作btn囉囉囉囉囉囉囉囉囉喔
            _btnPressArray = [[NSMutableArray alloc]init];
            
            for (int i = 0;i!=_btnArray.count; i++) {
                            UIButton *detailbtn = [UIButton buttonWithType:UIButtonTypeCustom];
                            [detailbtn addTarget:self
                                          action:@selector(DJBtnPressed:)
                                forControlEvents:UIControlEventTouchUpInside];
                
                [detailbtn setTitle:_btnArray[i] forState:UIControlStateNormal];
                [detailbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [detailbtn setTitleColor:[UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0] forState:UIControlStateSelected];
                
                detailbtn.backgroundColor = [UIColor blackColor];
                detailbtn.titleLabel.adjustsFontSizeToFitWidth = YES;

                detailbtn.layer.borderColor = [[UIColor colorWithRed:0.9 green:0.41 blue:0.15 alpha:1.0] CGColor];
                detailbtn.layer.borderWidth = 1.0f;
                detailbtn.frame = CGRectMake(width / 4 * i, 0, width / 4 , height );
                            [_btnScorllview addSubview:detailbtn];
                NSLog(@"%f, %f", _btnScorllview.frame.origin.x, _btnScorllview.frame.origin.y);

                NSLog(@"%f, %f", detailbtn.frame.origin.x, detailbtn.frame.origin.y);
                [_btnPressArray addObject:detailbtn];
            }
            
            }
        
    }];

    
    
}
-(void) DJBtnPressed:(UIButton *)sender {
    for (UIButton *btn in _btnPressArray) {
        btn.selected =NO;
        }
    
    UIButton *button = (UIButton *)sender;
    button.selected = YES;

    for (PFObject *Dj in _DJArray) {
        if ([button.titleLabel.text isEqualToString:Dj[@"name"]]) {
            NSLog(@"%@,%@",button.titleLabel.text, Dj[@"name"]);
            self.DJName.text = Dj[@"name"];
            self.DJTotalName.text = Dj[@"totalname"];
            self.DJLocation.text = Dj[@"location"];
            [self.youtubeView loadWithVideoId:Dj[@"youtube"]];
            UIView *hideView = [[UIView alloc]initWithFrame:_soundCloudView.frame];
//            建立一個view來蓋住webview
//            hideView.backgroundColor = [UIColor blackColor];
//            [self.view addSubview:hideView];
//            [self.view bringSubviewToFront:hideView];
            NSURL *url = [NSURL URLWithString:Dj[@"soundcloud"]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [_soundCloudView loadRequest:request];
//            hideView.hidden =YES;
            
            
            NSData *data = [Dj[@"photo"] getData];
            UIImage *image = [[UIImage alloc]initWithData:data];
            self.DJImageView.image = image;
            
            


            
        }
    }
   
}

- (void) presentLeftMenuViewController{
    
    //show left menu with animation
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
    
}
@end
