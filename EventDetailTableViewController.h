//
//  EventDetailTableViewController.h
//  ProjTipsy
//
//  Created by pp1285 on 2015/10/29.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventPicTableViewCell.h"
#import "MKPartyAnnotation.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface EventDetailTableViewController : UITableViewController <UIScrollViewDelegate,MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    BOOL isFirstGetLocation;
}

@property (weak, nonatomic) IBOutlet MKMapView *partyMap;

@property (weak, nonatomic) IBOutlet UIImageView *partyPicView;

@property (weak, nonatomic) IBOutlet UILabel *subjects;

@property (weak, nonatomic) IBOutlet UILabel *store;

@property (weak, nonatomic) IBOutlet UILabel *price;

@property (strong, nonatomic) NSMutableDictionary *Detaildic;

@property (nonatomic) CLLocationCoordinate2D coordinateStore;

@property (weak, nonatomic) IBOutlet EventPicTableViewCell *EventPicTableViewCell;




+(instancetype) controller;




@end
