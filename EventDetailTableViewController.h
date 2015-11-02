//
//  EventDetailTableViewController.h
//  ProjTipsy
//
//  Created by pp1285 on 2015/10/29.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventPicTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MKPartyAnnotation.h"
@interface EventDetailTableViewController : UITableViewController<UIScrollViewDelegate>
{
    CLLocationManager *locationManager;
    BOOL isFirstGetLocation;
    CLLocationCoordinate2D coordinate101;
}

@property (weak, nonatomic) IBOutlet MKMapView *partyMap;



@property (weak, nonatomic) IBOutlet EventPicTableViewCell *EventPicTableViewCell;

+(instancetype) controller;




@end
