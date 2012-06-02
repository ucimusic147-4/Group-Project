//
//  Singleton.h
//  MySecondApp
//
//  Created by Kojiro Umezaki on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AQPlayer.h"
#import "Sequencer.h"

#define kFilteringFactor 0.1

@interface Singleton : NSObject <UIAccelerometerDelegate> {
    
    AQPlayer*   aqp;
    
    Sequencer*  q;
    
    BOOL flipover;

    // creating basic filter object    
    BOOL adaptive;
	UIAccelerationValue x, y, z; 

}

-(void)updateTime:(Float64)elapsed_time;

-(void)touchX:(Float64)x;

-(void)playToggle;

/*
-(void)addAcceleration:(UIAcceleration*)accel;

@property(nonatomic, readonly) UIAccelerationValue x;
@property(nonatomic, readonly) UIAccelerationValue y;
@property(nonatomic, readonly) UIAccelerationValue z;

@property(nonatomic, getter=isAdaptive) BOOL adaptive;
@property(nonatomic, readonly) NSString *name;

@end

// A filter class to represent a lowpass filter
@interface LowpassFilter : Singleton
{
	double filterConstant;
	UIAccelerationValue lastX, lastY, lastZ;
}

-(id)initWithSampleRate:(double)rate cutoffFrequency:(double)freq;
*/


@end
