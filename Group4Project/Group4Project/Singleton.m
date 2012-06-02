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

@implementation Singleton
/*
@synthesize x, y, z, adaptive; // synthesizing properties defining UIacceleration values
*/
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
    
   // [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    
    return self;
}

-(void)dealloc
{
}

-(void)updateTime:(Float64)elapsed_time
{
    [q updateTime:elapsed_time];
}
/*
-(void)addAcceleration:(UIAcceleration*)accel
{
	x = accel.x;
	y = accel.y;
	z = accel.z;
}

-(NSString*)name
{
	return @"You should not see this";
}

@end

#define kAccelerometerMinStep				0.02
#define kAccelerometerNoiseAttenuation		3.0

double Norm(double x, double y, double z)
{
	return sqrt(x * x + y * y + z * z);
}

double Clamp(double v, double min, double max)
{
	if(v > max)
		return max;
	else if(v < min)
		return min;
	else
		return v;
}

// See http://en.wikipedia.org/wiki/Low-pass_filter for details low pass filtering
@implementation LowpassFilter

-(id)initWithSampleRate:(double)rate cutoffFrequency:(double)freq
{
	self = [super init];
	if(self != nil)
	{
		double dt = 1.0 / rate;
		double RC = 1.0 / freq;
		filterConstant = dt / (dt + RC);
	}
	return self;
}

-(void)addAcceleration:(UIAcceleration*)accel
{
	double alpha = filterConstant;
	
	if(adaptive)
	{
		double d = Clamp(fabs(Norm(x, y, z) - Norm(accel.x, accel.y, accel.z)) / kAccelerometerMinStep - 1.0, 0.0, 1.0);
		alpha = (1.0 - d) * filterConstant / kAccelerometerNoiseAttenuation + d * filterConstant;
	}
	
	x = accel.x * alpha + x * (1.0 - alpha);
	y = accel.y * alpha + y * (1.0 - alpha);
	z = accel.z * alpha + z * (1.0 - alpha);
}

-(NSString*)name
{
	return adaptive ? @"Adaptive Lowpass Filter" : @"Lowpass Filter";
}

@end

 */

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
    
    if (acceleration.z >= 0.6)
    {   NSLog(@"device has turned over");
        if (acceleration.z < -0.6)
        {
            // insert our function i.e. change instrument/song
            NSLog(@"successful");
        }
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
