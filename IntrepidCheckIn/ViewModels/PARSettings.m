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

@end
