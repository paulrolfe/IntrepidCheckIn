//
//  PARLocationTracker.h
//  IntrepidCheckIn
//
//  Created by Paul Rolfe on 6/16/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PARLocationTracker : NSObject <CLLocationManagerDelegate>

- (void)startMonitoringForIntrepid;
- (void)stopMonitoring;
- (BOOL)isMonitoringForIntrepidRegion;

@end
