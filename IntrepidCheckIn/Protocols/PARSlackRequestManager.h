//
//  PARSlackRequestManager.h
//  IntrepidCheckIn
//
//  Created by Paul Rolfe on 6/16/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PARSlackRequestManager : NSObject

+ (instancetype)sharedManager;
- (void)sendSlackMessage:(NSString *)message
                 success:(void (^)(BOOL success))success
                 failure:(void (^)(NSError *error))failure;

- (void)uploadAndSavePhoto:(UIImage *)photo;

@end
