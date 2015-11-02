//
//  CommentsTableViewController.h
//  ProjTipsy
//
//  Created by LINCHUNGYAO on 2015/11/1.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
@interface CommentsTableViewController : PFQueryTableViewController

@property(strong,nonatomic) NSString  *objectID;

@end
