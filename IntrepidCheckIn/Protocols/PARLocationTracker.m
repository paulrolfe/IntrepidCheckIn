//
//  PARLocationTracker.m
//  IntrepidCheckIn
//
//  Created by Paul Rolfe on 6/16/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "PARLocationTracker.h"
#import "PARSlackRequestManager.h"

@interface PARLocationTracker ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation PARLocationTracker

- (instancetype)init{
    if (self = [super init]){
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.delegate = self;
    }
    return self;
}

#pragma mark - Public methods

- (void)startMonitoringForIntrepid{
    [self.locationManager startMonitoringForRegion:[self intrepidOffice]];
}

- (void)stopMonitoring{
    [self.locationManager stopMonitoringForRegion:self.locationManager.monitoredRegions.anyObject];
}

- (BOOL)isMonitoringForIntrepidRegion{
    NSLog(@"%lu",self.locationManager.monitoredRegions.count);
    return self.locationManager.monitoredRegions.count >= 1;
}

#pragma mark - Private methods

- (CLRegion *)intrepidOffice{
    CLLocationCoordinate2D intrepidPoint = CLLocationCoordinate2DMake(42.36706,-71.080173);
    CLRegion *intrepid = [[CLCircularRegion alloc] initWithCenter:intrepidPoint radius:50 identifier:@"intrepidRegion"];
    return intrepid;
}

- (void)showLocalNotificationWithMessage:(NSString *)message{
    UILocalNotification * hey = [[UILocalNotification alloc] init];
    hey.alertBody = message;
    hey.soundName=UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:hey];
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    [[PARSlackRequestManager sharedManager] sendSlackMessage:@"I just got to the office :)"
                                                     success:^(BOOL success) {
                                                         [self showLocalNotificationWithMessage:@"You're in the office!"];
                                                     }
                                                     failure:^(NSError *error) {
                                                         NSLog(@"%@",error.localizedDescription);
                                                     }];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    [[PARSlackRequestManager sharedManager] sendSlackMessage:@"I just left the office :("
                                                     success:^(BOOL success) {
                                                         [self showLocalNotificationWithMessage:@"You're leaving the office!"];
                                                     }
                                                     failure:^(NSError *error) {
                                                         NSLog(@"%@",error.localizedDescription);
                                                     }];
}

@end
