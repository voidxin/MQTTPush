//
//  BackgroundTask.m
//  AUDIO + VOIP 
//
//  Created by Ravishanker Kusuma on 12/31/13.
//

#import "BackgroundTask.h"
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

void interruptionListenerCallback (void *inUserData, UInt32 interruptionState);

@implementation BackgroundTask

-(id) init
{
    self = [super init];
    if(self)
    {
        bgTask =UIBackgroundTaskInvalid;
        expirationHandler =nil;
        timer =nil;

    }
    return  self;
    
}

-(void) startBackgroundTasks:(NSInteger)time_  target:(id)target_ selector:(SEL)selector_
{
    timerInterval =time_;
    target = target_;
    selector = selector_;
    
    [self initBackgroudTask];
    
    //minimum 600 sec
    [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{
        [self initBackgroudTask];
    }];
}
-(void) initBackgroudTask
{
    
    dispatch_async(dispatch_get_main_queue(), ^(void)
    {
        if([self running])
            [self stopAudio];
        
         while([self running])
         {
             [NSThread sleepForTimeInterval:10]; //wait for finish
         }
         [self playAudio];
    });

}
- (void) audioInterrupted:(NSNotification*)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    NSNumber *interuptionType = [interuptionDict valueForKey:AVAudioSessionInterruptionTypeKey];
    if([interuptionType intValue] == 1)
    {
        [self initBackgroudTask];
    }
    
}
void interruptionListenerCallback (void *inUserData, UInt32 interruptionState)
{
    NSLog(@"Got Interrupt######");
    if (interruptionState == kAudioSessionBeginInterruption)
    {
       /// [self initBackgroudTask];
    }
}
-(void) playAudio
{
    
    UIApplication * app = [UIApplication sharedApplication];
    NSString *version = [[UIDevice currentDevice] systemVersion];

    if([version floatValue] >= 6.0f)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioInterrupted:) name:AVAudioSessionInterruptionNotification object:nil];
    }
    else
    {
        AudioSessionInitialize(NULL, NULL, interruptionListenerCallback, nil);

    }
//    expirationHandler = ^{
//        [app endBackgroundTask:bgTask];
//        bgTask = UIBackgroundTaskInvalid;
//        [timer invalidate];
//        [player stop];
//        NSLog(@"###############Background Task Expired.");
//       // [self playMusic];
//    };
    bgTask = [app beginBackgroundTaskWithExpirationHandler:expirationHandler];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        const char bytes[] = {0x52, 0x49, 0x46, 0x46, 0x26, 0x0, 0x0, 0x0, 0x57, 0x41, 0x56, 0x45, 0x66, 0x6d, 0x74, 0x20, 0x10, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, 0x44, 0xac, 0x0, 0x0, 0x88, 0x58, 0x1, 0x0, 0x2, 0x0, 0x10, 0x0, 0x64, 0x61, 0x74, 0x61, 0x2, 0x0, 0x0, 0x0, 0xfc, 0xff};
        NSData* data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
        NSString * docsDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        
        // Build the path to the database file
        NSString * filePath = [[NSString alloc] initWithString:
                               [docsDir stringByAppendingPathComponent: @"background.wav"]];
        [data writeToFile:filePath atomically:YES];
        NSURL *soundFileURL = [NSURL fileURLWithPath:filePath];
        OSStatus osStatus;
        NSError * error;
        if([version floatValue] >= 6.0f)
        {

            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
            [[AVAudioSession sharedInstance] setActive: YES error: &error];
            
        }
        else
        {
            osStatus = AudioSessionSetActive(true);
            
            UInt32 category = kAudioSessionCategory_MediaPlayback;
            osStatus = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
            
            UInt32 allowMixing = true;
            osStatus = AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof (allowMixing), &allowMixing );
        }

        player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
        player.volume = 0.01;
        player.numberOfLoops = -1; //Infinite
        [player prepareToPlay];
        [player play];
        timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:target selector:selector userInfo:nil repeats:YES];
        
    });
}

-(void) stopAudio
{
    NSString *version = [[UIDevice currentDevice] systemVersion];

    if([version floatValue] >= 6.0f)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:nil];
    }
    if(timer != nil && [timer isValid])
        [timer invalidate];
    
    if(player != nil && [player isPlaying])
        [player stop];

    if(bgTask != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask=UIBackgroundTaskInvalid;
    }
}
-(BOOL) running
{
    if(bgTask == UIBackgroundTaskInvalid)
        return FALSE;
    return TRUE;
}
-(void) stopBackgroundTask
{
    [self stopAudio];
}
@end
