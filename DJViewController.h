//
//  DJViewController.h
//  ProjTipsy
//
//  Created by pp1285 on 2015/11/4.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import <WebKit/WebKit.h>

@interface DJViewController : UIViewController {
}
+ (instancetype) controller;
@property (strong, nonatomic) NSMutableDictionary *DJdic;
@property (strong, nonatomic) NSMutableArray *DJArray;
@property (strong, nonatomic) NSMutableArray *DJPicArray;

@property (strong, nonatomic) NSMutableArray *btnArray;
@property (strong, nonatomic) NSMutableArray *btnPressArray;

@property (weak, nonatomic) IBOutlet UIScrollView *btnScorllview;

@property (weak, nonatomic) IBOutlet YTPlayerView *youtubeView;

@property (weak, nonatomic) IBOutlet WKWebView *soundCloudView;
@property (weak, nonatomic) IBOutlet UIImageView *DJImageView;
@property (weak, nonatomic) IBOutlet UILabel *DJName;
@property (weak, nonatomic) IBOutlet UILabel *DJTotalName;
@property (weak, nonatomic) IBOutlet UILabel *DJLocation;

@end
