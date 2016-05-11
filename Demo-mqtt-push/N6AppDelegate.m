//
//  N6AppDelegate.m
//  Demo-mqtt-push
//
//  Created by Guo Yu on 14-9-1.
//  Copyright (c) 2014年 non6. All rights reserved.
//

#import "N6AppDelegate.h"
#import "MMPushService.h"

@implementation N6AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil]];
    
    [[MMPushService sharedService]reconnect];
    
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
//    [application setKeepAliveTimeout:601 handler:^{
//       [[MMPushService sharedService]reconnect];
//    }];
    
    bgTask=[[BackgroundTask alloc]init];
    
    [bgTask startBackgroundTasks:2 target:self selector:@selector(backgroundCallback:)];
    
    //
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:3];
}

-(void) backgroundCallback:(id)info
{
//    NSLog(@"########");
//    NSLog(@"###### BG TASK RUNNING");
    
}

//本地推送会调用的协议方法
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"推送信息已经获得： %@",[notification alertBody]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[notification alertBody] delegate:self cancelButtonTitle:nil otherButtonTitles:@"good", nil];
    [alert show];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
