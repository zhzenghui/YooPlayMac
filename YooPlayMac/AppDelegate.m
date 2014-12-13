//
//  AppDelegate.m
//  YooPlayMac
//
//  Created by bejoy on 14/11/20.
//  Copyright (c) 2014年 zeng. All rights reserved.
//

#import "AppDelegate.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"



@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

//- (void)application:(NSApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity {
//    
//    [userActivity addUserInfoEntriesFromDictionary:@{
//                                                     @"handoffVersion": @"2.0",
//                                                     }];
//}
//
//
//- (BOOL)application:(NSApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType {
//    
//    
//    if ( [userActivityType isEqual:@"com.yooyoi.yooplay"]) {
//
//        
//        return YES;
//    }
//    return NO;
//}
//
//
//
//- (BOOL)application:(NSApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler {
//    
//    
//    return YES;
//}



@end
