//
//  PARAppDelegate.m
//  IntrepidCheckIn
//
//  Created by Paul Rolfe on 6/16/15
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#warning To run this correctly, you must set an appropriate Contants.h and Constants.m with AWS info.

/*
 AWSRegionType const CognitoRegionType = AWSRegionUSEast1;
 AWSRegionType const DefaultServiceRegionType = AWSRegionUSEast1;
 NSString *const CognitoIdentityPoolId = @"";
 NSString *const S3BucketName = @"";
 */

#import "PARAppDelegate.h"
#import "PARMainViewController.h"
#import "PARSettings.h"
#import "Constants.h"
#import <AWSCore/AWSCore.h>

NSString *const DEFAULT_LEAVING = @"I just left the office :(";
NSString *const DEFAULT_ARRIVING = @"I just got to the office :)";


@implementation PARAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    PARMainViewController *mainVC = [[PARMainViewController alloc] initWithNibName:@"PARMainViewController" bundle:nil];
    [self.window setRootViewController:mainVC];
    [self.window makeKeyAndVisible];
    
    UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
    [application registerUserNotificationSettings:settings];
    
    NSError *error = nil;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:[[PARAppDelegate applicationDocumentsDirectory] stringByAppendingPathComponent:@"upload"]
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:&error]) {
        NSLog(@"reading 'upload' directory failed: [%@]", error);
    }
    
    AWSCognitoCredentialsProvider *credentialsProvider =
    [[AWSCognitoCredentialsProvider alloc] initWithRegionType:CognitoRegionType
                                               identityPoolId:CognitoIdentityPoolId];
    
    AWSServiceConfiguration *configuration =
    [[AWSServiceConfiguration alloc] initWithRegion:DefaultServiceRegionType
                                credentialsProvider:credentialsProvider];
    AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
    
    if (![PARSettings leavingMessage]){
        [PARSettings setLeavingMessage:DEFAULT_LEAVING];
    }
    if (![PARSettings arrivingMessage]){
        [PARSettings setArrivingMessage:DEFAULT_ARRIVING];
    }
    
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application{
    UILocalNotification * hey = [[UILocalNotification alloc] init];
    hey.alertBody = @"Location monitoring has stopped. Please restart IN-trepid to enable check-ins.";
    hey.soundName=UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:hey];
}

+ (NSString *)applicationDocumentsDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

@end
