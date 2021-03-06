//
//  PARSettings.h
//  IntrepidCheckIn
//
//  Created by Paul Rolfe on 6/16/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PARSettings : NSObject

+ (void) setNameOfEmployee:(NSString *)name;
+ (NSString *)nameOfEmployee;

+ (void) setIconWebURL:(NSString *)iconURL;
+ (NSString *)iconWebURL;

+ (void) setLeavingMessage:(NSString *)message;
+ (NSString *)leavingMessage;

+ (void) setArrivingMessage:(NSString *)message;
+ (NSString *)arrivingMessage;

@end
