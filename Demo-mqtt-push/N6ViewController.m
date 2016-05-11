//
//  N6ViewController.m
//  Demo-mqtt-push
//
//  Created by Guo Yu on 14-9-1.
//  Copyright (c) 2014年 non6. All rights reserved.
//

#import "N6ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioUnit/AudioUnit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudio/CoreAudioTypes.h>
@interface N6ViewController ()<AVAudioPlayerDelegate>
@property(nonatomic,strong)AVAudioPlayer *audioPlayer;
@end

@implementation N6ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
    
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
