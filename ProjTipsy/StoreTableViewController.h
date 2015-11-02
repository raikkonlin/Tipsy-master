//
//  StoreTableViewController.h
//  ProjTipsy
//
//  Created by LINCHUNGYAO on 2015/10/22.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface StoreTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

//+ (instancetype) controller;
@property (nonatomic, strong) NSString *storeName;
@property (nonatomic, strong) NSString *dateTime;
@property (nonatomic, strong) PFFile *imageFile;
@property (nonatomic, strong) NSString *storeDescription;

@end
