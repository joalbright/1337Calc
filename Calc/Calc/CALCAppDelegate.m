//
//  CALCAppDelegate.m
//  Calc
//
//  Created by Jo Albright on 1/16/14.
//  Copyright (c) 2014 Jo Albright. All rights reserved.
//

#import "CALCAppDelegate.h"

#import "CALCRootViewController.h"

#import <Crashlytics/Crashlytics.h>

@implementation CALCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = [[CALCRootViewController alloc] init];
    
    [Crashlytics startWithAPIKey:@"a26d0a2d3d3631b380d39fead4eadf0728fb51e9"];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
