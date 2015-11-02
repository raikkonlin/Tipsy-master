//
//  MKPartyAnnotation.m
//  ProjTipsy
//
//  Created by pp1285 on 2015/10/30.
//  Copyright © 2015年 LINCHUNGYAO. All rights reserved.
//

#import "MKPartyAnnotation.h"

@implementation MKPartyAnnotation
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
-(id)initWithCoordinate:(CLLocationCoordinate2D)argCoordinate title:
(NSString*)argTitle subtitle:(NSString*)argSubtitle
{
    self = [super init];
    if(self)
    {
        coordinate = argCoordinate;
        title = argTitle;
        subtitle = argSubtitle;
    }
    return self;
}


@end
