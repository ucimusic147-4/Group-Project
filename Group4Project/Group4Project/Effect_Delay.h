//
//  Effect_Delay.h
//  Music147
//
//  Created by Kojiro Umezaki on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AQPlayer.h"
#import "Effect.h"

#define kMaxDelayTime		5.0
#define kMaxDelaySamples	(UInt32)(kSR * kMaxDelayTime)

@interface Effect_Delay : Effect {
	
	Float64	delayBuffer[kMaxDelaySamples];
	UInt32	readPos;
	UInt32	writePos;
	
	Float64 delayAmp;
	Float64 delayTime;
}

@property (readwrite) Float64 delayAmp;
@property (readwrite) Float64 delayTime;

-(void) process:(Float64*)buffer:(UInt32)num_samples;

@end
