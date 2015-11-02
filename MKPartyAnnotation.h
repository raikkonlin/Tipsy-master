//
//  MKPartyAnnotation.h
//  ProjTipsy
//
//  Created by pp1285 on 2015/10/30.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MKPartyAnnotation : NSObject <MKAnnotation>

-(id)initWithCoordinate:(CLLocationCoordinate2D)argCoordinate
                  title:(NSString*)argTitle subtitle:(NSString*)argSubtitle;


@end
