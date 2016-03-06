//
//  LFTAppDelegate.m
//  LFTPopView
//
//  Created by Theodore Felix Leo on 03/07/2016.
//  Copyright (c) 2016 Theodore Felix Leo. All rights reserved.
//

#import "LFTAppDelegate.h"
#import "LFTViewController.h"

@implementation LFTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    LFTViewController *viewController = [[LFTViewController alloc] init];
    self.window.rootViewController = viewController;
    
    return YES;
}

@end
