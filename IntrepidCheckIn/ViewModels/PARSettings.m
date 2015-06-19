//
//  PARSettings.m
//  IntrepidCheckIn
//
//  Created by Paul Rolfe on 6/16/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "PARSettings.h"

@implementation PARSettings

+ (void) setNameOfEmployee:(NSString *)name{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"kUsername"];
}
+ (NSString *)nameOfEmployee{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"kUsername"];
}

+ (void) setIconWebURL:(NSString *)iconURL{
    [[NSUserDefaults standardUserDefaults] setObject:iconURL forKey:@"kIconWebURL"];
}
+ (NSString *)iconWebURL{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"kIconWebURL"];
}

+ (void) setArrivingMessage:(NSString *)message{
    [[NSUserDefaults standardUserDefaults] setObject:message forKey:@"kArriveMessage"];
}
+ (NSString *) arrivingMessage{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"kArriveMessage"];
}

+ (void) setLeavingMessage:(NSString *)message{
    [[NSUserDefaults standardUserDefaults] setObject:message forKey:@"kLeaveMessage"];
}
+ (NSString *) leavingMessage{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"kLeaveMessage"];
}

@end
