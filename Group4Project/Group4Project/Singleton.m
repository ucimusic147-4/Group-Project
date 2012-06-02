//
//  Singleton.m
//  MySecondApp
//
//  Created by Kojiro Umezaki on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Singleton.h"

#import "AQPlayer_SF.h"
#import "AQPlayer_Synth.h"
#import "AQPlayer_SynthSF.h"

#import <UIKit/UIKit.h>

extern AQPlayer *aqp;

@implementation Singleton

-(id)init
{
    self = [super init];
    
    NSLog(@"Initializing Singleton object.");

    aqp = [[AQPlayer_SynthSF alloc] init];

    
    q = [[Sequencer alloc] init];
    [q setBpm:133];
    
    /* this is temporary just to test the new sequencer code */
    //Sequence* seq = [[Sequence alloc] init];
    //[q setSeq:seq];
    
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    
    return self;
}

-(void)dealloc
{
}

-(void)updateTime:(Float64)elapsed_time
{
    [q updateTime:elapsed_time];
}


-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    // Use a basic low-pass filter to keep only the gravity component of each axis.
    x = (acceleration.x * kFilteringFactor) + (x * (1.0 - kFilteringFactor));
    y = (acceleration.y * kFilteringFactor) + (y * (1.0 - kFilteringFactor));
    z = (acceleration.z * kFilteringFactor) + (z * (1.0 - kFilteringFactor));
    
    // Use the acceleration data.
    
    // Subtract the low-pass value from the current value to get a simplified high-pass filter
    x = acceleration.x - ( (acceleration.x * kFilteringFactor) + (x * (1.0 - kFilteringFactor)) );
    y = acceleration.y - ( (acceleration.y * kFilteringFactor) + (y * (1.0 - kFilteringFactor)) );
    z = acceleration.z - ( (acceleration.z * kFilteringFactor) + (z * (1.0 - kFilteringFactor)) );
    
    // Use the acceleration data.
    
    
    // change octaves/instrument/song when flipping over device
    if (acceleration.z >= 0.6)
    {
        flipover = YES;
        NSLog(@"device has turned over");
    }
    if (acceleration.z < -0.6 && flipover == YES)
    {
        flipover = NO;
        [(AQPlayer_SynthSF*)aqp changeVoices];
        NSLog(@"successful");
    }
    
    // play sound when rotating device <= 90 degrees
    if (acceleration.y >= -0.6)
    {
        rotate = YES;
        NSLog(@"device has rotated");
    }
    if (acceleration.y < -0.9 && rotate == YES)
    {
        rotate = NO;
        [aqp voiceOn:1];
        NSLog(@"ding!");
        
    }
    
    
    NSLog(@"%f %f %f",acceleration.x,acceleration.y,acceleration.z);
}

-(void)touchX:(Float64)x
{
    NSLog(@"touchX %lf",x);
    [(AQPlayer_SynthSF*)aqp filterFreq:x*10000.];
}

-(void)playToggle
{
    [(AQPlayer_SynthSF*)aqp playToggle];
}

@end
