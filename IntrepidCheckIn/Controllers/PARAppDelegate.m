//
//  PARAppDelegate.m
//  IntrepidCheckIn
//
//  Created by Paul Rolfe on 6/16/15
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "PARAppDelegate.h"
#import "PARMainViewController.h"

@implementation PARAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    PARMainViewController *mainVC = [[PARMainViewController alloc] initWithNibName:@"PARMainViewController" bundle:nil];
    [self.window setRootViewController:mainVC];
    [self.window makeKeyAndVisible];
    
    UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
    [application registerUserNotificationSettings:settings];
    
    return YES;
}

@end
