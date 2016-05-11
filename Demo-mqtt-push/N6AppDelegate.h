//
//  N6AppDelegate.h
//  Demo-mqtt-push
//
//  Created by Guo Yu on 14-9-1.
//  Copyright (c) 2014年 non6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackgroundTask.h"
@interface N6AppDelegate : UIResponder <UIApplicationDelegate>
{
    BackgroundTask * bgTask;
}
@property (strong, nonatomic) UIWindow *window;

@end
