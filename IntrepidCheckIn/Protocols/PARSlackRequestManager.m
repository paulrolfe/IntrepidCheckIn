//
//  PARSlackRequestManager.m
//  IntrepidCheckIn
//
//  Created by Paul Rolfe on 6/16/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "PARSlackRequestManager.h"
#import "PARSettings.h"
#import <AFNetworking/AFNetworking.h>

@implementation PARSlackRequestManager

+ (instancetype)sharedManager{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)sendSlackMessage:(NSString *)message
                 success:(void (^)(BOOL success))success
                 failure:(void (^)(NSError *error))failure {
    NSLog(@"Would send a message");

    NSDictionary *params = @{@"text":message, @"username":[PARSettings nameOfEmployee]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:@"https://hooks.slack.com/services/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"
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"Success: %@",operation.request.description);
              if (success)
                  success(YES);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (failure)
                  failure(error);
          }];
}

@end
