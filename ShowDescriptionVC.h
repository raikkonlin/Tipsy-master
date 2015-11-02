    //
    //  ShowDescriptionVC.h
    //  ProjTipsy
    //
    //  Created by LINCHUNGYAO on 2015/10/30.
    //  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
    //

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface ShowDescriptionVC : UIViewController

@property (nonatomic, strong) NSString *storeName;
@property (nonatomic, strong) NSString *likeLabel;
@property (nonatomic, strong) PFFile *imageFile1;
@property (nonatomic, strong) PFFile *imageFile2;
@property (nonatomic, strong) PFFile *imageFile3;
@property (nonatomic, strong) NSString *movieDescription;
@property (nonatomic, strong) NSString *objectID;

@property(nonatomic, getter = shouldHideStatusBar) BOOL hideStatusBar;

@end
