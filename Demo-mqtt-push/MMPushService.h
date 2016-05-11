//
//  MMPushService.h
//  yuxi-manager
//
//  Created by Guo Yu on 14-8-27.
//  Copyright (c) 2014年 ylink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMPushService : NSObject

+ (MMPushService *)sharedService;

- (void)reconnect;




@end
