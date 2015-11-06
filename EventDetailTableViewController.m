//
//  EventDetailTableViewController.m
//  ProjTipsy
//
//  Created by pp1285 on 2015/10/29.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import "EventDetailTableViewController.h"
#import "AppDelegate.h"
#import "ITRAirSideMenu.h"
#import "EventPicTableViewCell.h"



@implementation EventDetailTableViewController 
+(instancetype) controller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([EventDetailTableViewController class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor blackColor];
    [self setViewDetail];
    [locationManager startUpdatingLocation];
    
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 8;
}



-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    isFirstGetLocation  = NO;
    
    //    地圖
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
}


- (void) presentLeftMenuViewController{
     
     //show left menu with animation
     ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
     [itrSideMenu presentLeftMenuViewController];
     
 }



- (IBAction)menuButtonPress:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<=0) {
        scrollView.contentOffset = CGPointZero;
    }
}
-(void)sendDetail:(NSNotification *)noti{
    
    NSDictionary *currentPagedic = noti.userInfo;
    _Detaildic = [currentPagedic mutableCopy] ;
    NSLog(@"detaildic %@", _Detaildic);
    
}

-(void)setViewDetail {
    _partyPicView.image = _Detaildic[@"picture"];
    _subjects.numberOfLines = 0;
    _subjects.lineBreakMode = NSLineBreakByWordWrapping;
    _subjects.text = _Detaildic[@"subjects"];
    _store.numberOfLines = 0;
    _store.lineBreakMode = NSLineBreakByWordWrapping;
    _store.text = _Detaildic[@"store"];
    _price.numberOfLines = 0;
    _price.lineBreakMode = NSLineBreakByWordWrapping;
    _price.text = _Detaildic[@"price"];
    
    self.EventPicTableViewCell.picScrollView.contentSize = CGSizeMake(4* [UIScreen mainScreen].bounds.size.width /2, self.EventPicTableViewCell.frame.size.height -16 );
    CGRect Frame = CGRectMake(8,8 , [UIScreen mainScreen].bounds.size.width /2,self.EventPicTableViewCell.frame.size.height );
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:Frame];
    imageView.image = [UIImage imageNamed:@"lava"];
    
    Frame = CGRectMake([UIScreen mainScreen].bounds.size.width /2 +16, 8 , [UIScreen mainScreen].bounds.size.width /2, self.EventPicTableViewCell.frame.size.height);
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:Frame];
    imageView2.image = [UIImage imageNamed:@"lava2"];
    Frame = CGRectMake(2*[UIScreen mainScreen].bounds.size.width /2 +24, 8 , [UIScreen mainScreen].bounds.size.width /2, self.EventPicTableViewCell.frame.size.height);
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:Frame];
    imageView3.image = [UIImage imageNamed:@"lava3"];
    Frame = CGRectMake(3*[UIScreen mainScreen].bounds.size.width /2 +32, 8 , [UIScreen mainScreen].bounds.size.width /2, self.EventPicTableViewCell.frame.size.height);
    
    UIImageView *imageView4 = [[UIImageView alloc] initWithFrame:Frame];
    imageView4.image = [UIImage imageNamed:@"lava4"];
    
    
    
    [self.EventPicTableViewCell.picScrollView addSubview:imageView];
    [self.EventPicTableViewCell.picScrollView addSubview:imageView2];
    [self.EventPicTableViewCell.picScrollView addSubview:imageView3];
    [self.EventPicTableViewCell.picScrollView addSubview:imageView4];
    
    
    _coordinateStore = CLLocationCoordinate2DMake([_Detaildic[@"latitude"] doubleValue], [_Detaildic[@"longtitude"] doubleValue]);
    [self addAnnotation];
//    [self mapView: _partyMap didUpdateUserLocation:nil];
//    MKCoordinateRegion region ;
//    region.center = _coordinateStore;
//    MKCoordinateSpan mapSpan;
//    mapSpan.latitudeDelta = 0.004;
//    mapSpan.longitudeDelta = 0.004;
//    region.span = mapSpan;
//    [_partyMap setRegion:region animated:YES];
   }
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:
(MKUserLocation *)userLocation
{
    if(isFirstGetLocation == NO) {
        
        isFirstGetLocation = YES;
        MKCoordinateRegion region ;
        MKCoordinateSpan mapSpan;
        region.center = userLocation.location.coordinate;
    
        mapSpan.latitudeDelta = ABS(_coordinateStore.latitude -
                                    userLocation.location.coordinate.latitude)*2.1;
        mapSpan.longitudeDelta = ABS(_coordinateStore.longitude -
                                     userLocation.location.coordinate.longitude)*2.1;
        region.span = mapSpan;
    
//        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate,200, 200 );
//    
//        MKCoordinateSpan mapSpan;
        region.span = mapSpan;
    
        
        NSLog(@"region @", userLocation);
        
        [_partyMap setRegion:region animated:YES];
    }

}

-(void)addAnnotation {
    CLLocationCoordinate2D coordinateStore =
    CLLocationCoordinate2DMake([_Detaildic[@"latitude"] doubleValue], [_Detaildic[@"longtitude"] doubleValue]);
    MKPartyAnnotation *annotation = [[MKPartyAnnotation alloc]
                                initWithCoordinate:coordinateStore
                                title:_Detaildic[@"store"]subtitle:nil];
    [_partyMap addAnnotation:annotation];
}
@end
