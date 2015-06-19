//
//  PARSlackRequestManager.m
//  IntrepidCheckIn
//
//  Created by Paul Rolfe on 6/16/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "PARSlackRequestManager.h"
#import "PARSettings.h"
#import <AWSS3/AWSS3.h>
#import <AFNetworking/AFNetworking.h>
#import "PARAppDelegate.h"

NSString *const S3_BUCKET = @"Paul.Image.Bucket";
NSString *const S3_BASE_URL = @"https://s3.amazonaws.com/Paul.Image.Bucket";

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

    NSDictionary *params = @{@"text":message,
                             @"username":[PARSettings nameOfEmployee],
                             @"icon_url":[PARSettings iconWebURL]};
    
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

- (void)uploadAndSavePhoto:(UIImage *)photo{
    //We need a file url of the data.
    NSString *fileName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingString:@".png"];
    NSString *filePath = [[[PARAppDelegate applicationDocumentsDirectory] stringByAppendingPathComponent:@"upload"] stringByAppendingPathComponent:fileName];
    NSData *imageData = UIImagePNGRepresentation(photo);
    
    [imageData writeToFile:filePath atomically:YES];
        
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.bucket = S3_BUCKET;
    uploadRequest.key = fileName;
    uploadRequest.body = [NSURL fileURLWithPath:filePath];
    uploadRequest.contentLength = [NSNumber numberWithUnsignedLong:imageData.length];
    
    [[transferManager upload:uploadRequest] continueWithBlock:^id(AWSTask *task) {
        if (task.result) {
            [PARSettings setIconWebURL:[NSString stringWithFormat:@"%@/%@",S3_BASE_URL,fileName]];
        }
        return nil;
    }];

}

@end
